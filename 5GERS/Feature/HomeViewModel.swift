//
//  HomeViewModel.swift
//  5GERS
//
//  Created by 이정동 on 7/30/24.
//

import Foundation
import UserNotifications

// TODO: State, Action으로 재정의하기
@Observable
final class HomeViewModel {
    
    // Common
    var outing: Outing = .init(time: .now, products: [])
    
    // Setting View
    var products: [TextFieldItem] = []
    var isPresentedProductsView: Bool = false
    var isPresentedOutingList: Bool = false
    
    // Timer View
    var isActiveLiveActivity: Bool = false
    var totalRemainingValue: Int = 7200
    var currentRemainingTimeValue: Int = 0 {
        didSet {
            let minus = Double(totalRemainingValue - min(currentRemainingTimeValue, totalRemainingValue))
            let div = minus / Double(totalRemainingValue)
            
            remainingPercent = Int(div * 360)
        }
    }
    var remainingPercent: Int = 0
    
    // TODO: DI 적용
    private let userDefaultsManager = UserDefaultsManager.shared
    private let notificationManager = NotificationManager.shared
    private let swiftDataManager = SwiftDataManager.shared
    private let liveActivityManager = LiveActivityManager.shared
    
    init() {
        self.initialData()
    }
    
    private func initialData() {
        self.outing = userDefaultsManager.getOutingData()
        self.isActiveLiveActivity = liveActivityManager.isActivateActivity()
        self.products = outing.products.map { TextFieldItem(text: $0) }
    }
}


// MARK: - ProductsView
extension HomeViewModel {
    func saveProductsButtonTapped(isInitialMode: Bool) {
        self.userDefaultsManager.setIsTodayAfter(true)
        // TODO: products에 빈 문자열이 없는 것만 추가
        self.outing.products = self.products.map { $0.text }
        
        self.outing.time = self.outing.time.timeFormat
        self.userDefaultsManager.setOutingData(self.outing)
        
        self.outing = userDefaultsManager.getOutingData()
        
        if isInitialMode {
            print("Initial")
            
            // TODO: 초기 설정 때 기준으로 남은 시간 가져오기 (UserDefaults에 따로 저장 필요할 듯)
            // 또는, 2시간 전부터 프로그래스바 흐르도록
            currentRemainingTimeValue = Int(outing.time.timeIntervalSinceNow)
            
            for timeInterval in [1800, 3600, 5400, 7200] {
                // TODO: 라이브 액티비티 활성화 유도 알림 등록 (지금은 1분 전으로)
                self.notificationManager.scheduleAlarmNotification(
                    content: .init(
                        body: .ready(time: outing.time.convertRemainingTime(from: outing.time.addingTimeInterval(TimeInterval(-timeInterval)))),
                        categoryIdentifier: .liveActivity
                    ),
                    at: outing.time.addingTimeInterval(TimeInterval(-timeInterval))
                )
            }
            
            // TODO: 외출시간에 알림
            self.notificationManager.scheduleAlarmNotification(
                content: .init(body: .end),
                at: outing.time
            )
            
        } else {
            print("Not")
            // 라이브액티비티 업데이트
            if isActiveLiveActivity {
                Task { await liveActivityManager.updateActivity(outing.products) }
            }
        }
    }
    
    func addProductButtonTapped() {
        self.products.insert(.init(text: ""), at: 0)
    }
    
    func deleteProductButtonTapped(at index: Int) {
        self.products.remove(at: index)
    }
}

// MARK: - HomeViewModel
extension HomeViewModel {
    // TODO: 함수명 변경
    func deleteOutingButtonTapped() {
        userDefaultsManager.setOutingData(Outing(time: .now, products: []))
        userDefaultsManager.setIsTodayAfter(false)
        notificationManager.removeAllAlarmNotification()
        Task { await liveActivityManager.endActivity() }
        initialData()
    }
    
    func liveActivityButtonTapped() {
        let isActive = liveActivityManager.isActivateActivity()
        
        if !isActive {
            try? liveActivityManager.startActivity(outing)
            notificationManager.removeLiveActivityNotification()
        }
        
        //isActiveLiveActivity = !isActive
    }
}
