//
//  _GERSApp.swift
//  5GERS
//
//  Created by 이정동 on 7/29/24.
//

import SwiftUI
import UserNotifications

@main
struct _GERSApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    init() {
        UNUserNotificationCenter.current().delegate = appDelegate
        
        NotificationManager.shared.requestPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
