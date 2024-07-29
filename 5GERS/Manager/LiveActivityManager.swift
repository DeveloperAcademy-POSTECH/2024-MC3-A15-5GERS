//
//  LiveActivityManager.swift
//  5GERS
//
//  Created by 이정동 on 7/29/24.
//

import Foundation
import ActivityKit

final class LiveActivityManager {
    static let shared = LiveActivityManager()
    private init() {}
    
    func startActivity(_ time: Date) throws {
        let attributes = LiveActivityWidgetAttributes(time: time)
        let state = LiveActivityWidgetAttributes.ContentState()
        
        do {
            let _ = try Activity.request(
                attributes: attributes,
                content: .init(
                    state: state,
                    staleDate: nil
                )
            )
        } catch {
            throw error
        }
    }
    
    func isActivateActivity() -> Bool {
        return !Activity<LiveActivityWidgetAttributes>.activities.isEmpty
    }
    
    func endActivity() async {
        for activity in Activity<LiveActivityWidgetAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }
}
