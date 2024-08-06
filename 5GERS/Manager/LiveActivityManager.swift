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
    
    func startActivity(_ outing: Outing) throws {
        let attributes = LiveActivityWidgetAttributes(time: outing.time)
        let state = LiveActivityWidgetAttributes.ContentState(products: outing.products)
        
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
    
    func updateActivity(_ products: [String]) async {
        if let activity = Activity<LiveActivityWidgetAttributes>.activities.first {
            await activity.update(.init(state: .init(products: products), staleDate: nil))
        }
    }
    
    func endActivity() async {
        for activity in Activity<LiveActivityWidgetAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }
}
