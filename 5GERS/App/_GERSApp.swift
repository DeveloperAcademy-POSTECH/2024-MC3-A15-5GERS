//
//  _GERSApp.swift
//  5GERS
//
//  Created by 이정동 on 7/29/24.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct _GERSApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @AppStorage(UserDefaultsKey.isTodayAfter) private var isTodayAfter: Bool = false
    
    init() {
        let outing = UserDefaultsManager.shared.getOutingData()
        if isTodayAfter && !outing.time.isAfterToday {
            UserDefaultsManager.shared.setOutingData(.init(time: .now, products: []))
            UserDefaultsManager.shared.setIsTodayAfter(false)
            Task { await LiveActivityManager.shared.endActivity() }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .modelContainer(for: OutingSD.self)
        }
    }
}
