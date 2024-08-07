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
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage(UserDefaultsKey.isTodayAfter) private var isTodayAfter: Bool = false
    
    init() {
        let outing = UserDefaultsManager.shared.getOutingData()
        if isTodayAfter && !outing.time.isAfterToday {
            UserDefaultsManager.shared.setOuting(nil)
            Task { await LiveActivityManager.shared.endActivity() }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .modelContainer(for: OutingSD.self)
        }
        .onChange(of: scenePhase, initial: true) {
            if case .active = $1 {
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            }
        }
    }
}
