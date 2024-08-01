//
//  HomeViewModel.swift
//  5GERS
//
//  Created by 이정동 on 7/30/24.
//

import Foundation
import UserNotifications

@Observable
final class HomeViewModel {
    
    // Common
    var outing: Outing = .init(time: .now, products: [])
    
    // Setting View
    var products: [TextFieldItem] = []
    var isPresentedProductsView: Bool = false
    var isPresentedOutingList: Bool = false
    
    // Timer View
    var timer: Timer?
    var isActiveLiveActivity: Bool = false
    
    private let userDefaultsManager = UserDefaultsManager.shared
    private let notificationManager = NotificationManager.shared
    private let swiftDataManager = SwiftDataManager.shared
    private let liveActivityManager = LiveActivityManager.shared
    
    init() {
        self.initialData()
    }
    
    private func initialData() {
        self.outing = userDefaultsManager.getOutingData()
        self.isActiveLiveActivity = false
        self.products = outing.products.map { TextFieldItem(text: $0) }
    }
}


// MARK: - ProductsView
extension HomeViewModel {
    func saveProductsButtonTapped() {
        userDefaultsManager.setIsTodayAfter(true)
        outing.products = products.map { $0.text }
        
        // TODO: products에 빈 문자열이 없는 것만 추가
        outing.time = outing.time.timeFormat
        userDefaultsManager.setOutingData(outing)
        
//        print(outing.time)
//        print(outing.time.addingTimeInterval(-60))
//        print(outing.time.remainingTimeFromNow)
        
        self.outing = userDefaultsManager.getOutingData()
        
        for timeInterval in [60, 120, 180] {
            // TODO: 라이브 액티비티 활성화 유도 알림 등록 (지금은 1분 전으로)
            notificationManager.scheduleAlarmNotification(
                content: .init(
                    body: .ready(time: outing.time.convertRemainingTime(from: outing.time.addingTimeInterval(TimeInterval(-timeInterval)))),
                    categoryIdentifier: .liveActivity
                ),
                at: outing.time.addingTimeInterval(TimeInterval(-timeInterval))
            )
        }
        
        
        // TODO: 외출시간에 알림
        notificationManager.scheduleAlarmNotification(
            content: .init(body: .end),
            at: outing.time
        )
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { list in
            print("Create--------------------------------")
            print(list)
        }
        
        // 라이브액티비티 업데이트
        if isActiveLiveActivity {
            Task { await liveActivityManager.updateActivity(outing.products) }
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
    func deleteOutingButtonTapped() {
        userDefaultsManager.removeOutingData()
        userDefaultsManager.setIsTodayAfter(false)
        notificationManager.removeAllAlarmNotification()
        Task { await liveActivityManager.endActivity() }
        initialData()
    }
    
    func liveActivityButtonTapped() {
        let isActive = liveActivityManager.isActivateActivity()
        
        if isActive {
            deleteOutingButtonTapped()
        } else {
            try? liveActivityManager.startActivity(outing)
            notificationManager.removeLiveActivityNotification()
        }
        
        isActiveLiveActivity = !isActive
    }
}
