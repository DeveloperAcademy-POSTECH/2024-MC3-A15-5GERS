//
//  LiveActivityWidgetLiveActivity.swift
//  LiveActivityWidget
//
//  Created by 이정동 on 7/29/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LiveActivityWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
    }

    // Fixed non-changing properties about your activity go here!
    var time: Date
}

struct LiveActivityWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text(context.attributes.time, style: .timer)
                    .monospacedDigit()
                    .multilineTextAlignment(.center)
                
                ProgressView(timerInterval: Date()...Date().addingTimeInterval(3500))
                    .labelsHidden()
                    .tint(.red)
                    .scaleEffect(y: 1.5)
            }
            .padding(20)
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                         
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                
            } minimal: {
                Text(context.attributes.time, style: .timer)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension LiveActivityWidgetAttributes {
    fileprivate static var preview: LiveActivityWidgetAttributes {
        LiveActivityWidgetAttributes(time: .now.addingTimeInterval(3600))
    }
}

//extension LiveActivityWidgetAttributes.ContentState {
//    fileprivate static var smiley: LiveActivityWidgetAttributes.ContentState {
//        LiveActivityWidgetAttributes.ContentState(emoji: "😀")
//     }
//     
//     fileprivate static var starEyes: LiveActivityWidgetAttributes.ContentState {
//         LiveActivityWidgetAttributes.ContentState(emoji: "🤩")
//     }
//}
//
#Preview("Notification", as: .content, using: LiveActivityWidgetAttributes.preview) {
   LiveActivityWidgetLiveActivity()
} contentStates: {
    LiveActivityWidgetAttributes.ContentState()
//    LiveActivityWidgetAttributes.ContentState.smiley
//    LiveActivityWidgetAttributes.ContentState.starEyes
}
