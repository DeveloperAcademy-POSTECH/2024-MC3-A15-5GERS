//
//  AppDelegate.swift
//  5GERS
//
//  Created by 이정동 on 7/29/24.
//

import Foundation
import UserNotifications
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        NotificationManager.shared.requestPermission()
        
        return true
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        
        
        // TODO: 카테고리에 따라 라이브 액티비티 활성화
        print("Identifier: \(response.notification.request.content.categoryIdentifier)")
        
        let data = UserDefaultsManager.shared.getOutingData()
        try? LiveActivityManager.shared.startActivity(data.time)
        
        // TODO: 라이브 액티비티 활성화 여부에 따라 추가 알림 등록
        
        completionHandler()
    }
}
