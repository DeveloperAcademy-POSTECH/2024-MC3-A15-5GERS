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
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        
        // TODO: Live Activity 활성화
        
        completionHandler()
    }
}
