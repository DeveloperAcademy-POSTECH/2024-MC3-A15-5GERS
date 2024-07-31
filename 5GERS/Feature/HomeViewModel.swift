//
//  HomeViewModel.swift
//  5GERS
//
//  Created by 이정동 on 7/30/24.
//

import Foundation


@Observable
final class HomeViewModel {
    
    // Common
    var outing: Outing = .init(time: .now, products: [])
    
    // Setting View
    var date: Date = .now
    var products: [TextFieldItem] = []
    var isPresentedProductsView: Bool = false
    var isPresentedOutingList: Bool = false
    
    // Timer View
    var timer: Timer?
    
    private let userDefaultsManager = UserDefaultsManager.shared
    private let notificationManager = NotificationManager.shared
    private let swiftDataManager = SwiftDataManager.shared
    private let liveActivityManager = LiveActivityManager.shared
    
    init() {
        self.outing = userDefaultsManager.getOutingData()
    }
}


// MARK: - ProductsView
extension HomeViewModel {
    func saveProductsButtonTapped() {
        // TODO: SettingView, TimerView에 따른 time 매개변수에 전달할 값 지정
        // TODO: products에 빈 문자열이 없는 것만 추가
        let new = Outing(time: date, products: products.map { $0.text })
        userDefaultsManager.setOutingData(new)
        
        self.outing = userDefaultsManager.getOutingData()
        
        // TODO: 라이브 액티비티 활성화 유도 알림 등록 (지금은 1분 전으로)
        notificationManager.scheduleAlarmNotification(at: date.addingTimeInterval(-60))
        // TODO: 외출시간에 알림
        notificationManager.scheduleAlarmNotification(at: date)
    }
    
    func addProductButtonTapped() {
        self.products.insert(.init(text: ""), at: 0)
    }
    
    func deleteProductButtonTapped(at index: Int) {
        self.products.remove(at: index)
    }
}
