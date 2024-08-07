//
//  NotificationManager.swift
//  5GERS
//
//  Created by 이정동 on 7/29/24.
//

import Foundation
import UserNotifications



struct NotificationContent {
    
    enum TitleType {
        case appName
        
        var value: String {
            switch self {
            case .appName: "지금 당장"
            }
        }
    }
    
    enum SubtitleType {
        case `default`
        
        var value: String {
            switch self {
            case .default: ""
            }
        }
    }
    
    enum BodyType {
        case ready(time: String)
        case comming(time: String)
        case end
        
        var value: String {
            switch self {
            case .ready(let time): "외출 시간까지 \(time) 남았습니다.\n실시간 현황을 통해 남은 시간을 확인해 보세요."
            case .comming(let time): "외출 시간까지 \(time) 남았습니다.\n소지품은 잘 챙기셨는지 확인해 보세요."
            case .end: "외출 준비가 종료되었습니다."
            }
        }
    }
    
    enum CategoryIdentifierType {
        case `default`
        case liveActivity
        
        var value: String {
            switch self {
            case .default: ""
            case .liveActivity: "liveActivity"
            }
        }
    }
    
    var title: TitleType
    var subtitle: SubtitleType
    var body: BodyType
    var sound: UNNotificationSound
    var categoryIdentifier: CategoryIdentifierType
    
    init(
        title: TitleType = .appName,
        subtitle: SubtitleType = .default,
        body: BodyType,
        sound: UNNotificationSound = .default,
        categoryIdentifier: CategoryIdentifierType = .default
    ) {
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.sound = sound
        self.categoryIdentifier = categoryIdentifier
    }
}

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
    
    func scheduleAllAlarmNotification(_ outing: Outing) {
        // 라이브 액티비티 활성화 유도 알림
        for timeInterval in [1800, 3600, 5400, 7200] {
            self.scheduleAlarmNotification(
                content: .init(
                    body: .ready(
                        time: outing.time.convertRemainingTime(
                            from: outing.time.addingTimeInterval(TimeInterval(-timeInterval))
                        )
                    ),
                    categoryIdentifier: .liveActivity
                ),
                at: outing.time.addingTimeInterval(TimeInterval(-timeInterval))
            )
        }
        
        // 외출 10분 전 알림
        self.scheduleAlarmNotification(
            content: .init(
                body: .comming(
                    time: outing.time.convertRemainingTime(
                        from: outing.time.addingTimeInterval(-600)
                    )
                )
            ),
            at: outing.time.addingTimeInterval(-600)
        )
        
        // 외출 알림
        self.scheduleAlarmNotification(
            content: .init(body: .end),
            at: outing.time
        )
    }
    
    private func scheduleAlarmNotification(content: NotificationContent, at date: Date) {
        let notiContent = UNMutableNotificationContent()
        notiContent.title = content.title.value
        notiContent.subtitle = content.subtitle.value
        notiContent.body = content.body.value
        notiContent.sound = content.sound
        notiContent.categoryIdentifier = content.categoryIdentifier.value
        
        
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notiContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            }
        }
    }
    
    func removeAllAlarmNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

    }
    
    func removeLiveActivityNotification() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            var identifiers: [String] = []
            for request in requests {
                if request.content.categoryIdentifier == NotificationContent.CategoryIdentifierType.liveActivity.value {
                    identifiers.append(request.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
}
