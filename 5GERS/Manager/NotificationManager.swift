//
//  NotificationManager.swift
//  5GERS
//
//  Created by 이정동 on 7/29/24.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(
                options: [.alert, .sound]
            ) { granted, error in
                if granted {
                    // 권한이 허용된 경우
                    print("Notification permission granted.")
                } else {
                    // 권한이 거부된 경우
                    print("Notification permission denied.")
                }
            }
    }
    
    func scheduleAlarmNotification(at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Custom Alarm"
        content.subtitle = "Subtitle"
        content.body = "It's time for your custom alarm!"
        content.sound = UNNotificationSound.default
        
        
        let triggerDate = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            }
        }
        
    }
}
