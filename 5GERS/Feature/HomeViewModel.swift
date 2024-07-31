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
    var isPresented: Bool = false
    
    // Timer View
    
    private let userDefaultsManager = UserDefaultsManager.shared
    private let notificationManager = NotificationManager.shared
    private let swiftDataManager = SwiftDataManager.shared
    private let liveActivityManager = LiveActivityManager.shared
    
    init() {
        self.outing = userDefaultsManager.getOutingData()
    }
}

extension HomeViewModel {
    func saveProductsButtonTapped() {
        // TODO: SettingView, TimerView에 따른 time 매개변수에 전달할 값 지정
        // TODO: products에 빈 문자열이 없는 것만 추가
        let new = Outing(time: date, products: products.map { $0.text })
        userDefaultsManager.setOutingData(new)
        
        self.outing = userDefaultsManager.getOutingData()
    }
    
    func addProductButtonTapped() {
        self.products.insert(.init(text: ""), at: 0)
    }
    
    func deleteProductButtonTapped(at index: Int) {
        self.products.remove(at: index)
    }
}
