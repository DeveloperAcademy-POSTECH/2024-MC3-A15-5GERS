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
    
    @State private var homeViewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(homeViewModel)
        }
    }
}
