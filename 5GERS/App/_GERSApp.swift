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
    
    @State private var homeViewModel = HomeViewModel()
    
    init() {
        if isTodayAfter && !homeViewModel.outing.time.isAfterToday {
            homeViewModel.deleteOutingButtonTapped()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(homeViewModel)
        }
    }
}
