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
        var products: [String]
    }

    // Fixed non-changing properties about your activity go here!
    var time: Date
}

struct LiveActivityWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityWidgetAttributes.self) { context in
            
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("챙길 소지품")
                            .font(.system(size: 15, weight: .medium))
                        Spacer()
                        
                        Text(context.state.products.joinWithComma())
                            .font(.system(size: 15, weight: .semibold))
                        Spacer()
                    }
                    .background(.red)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("외출까지")
                            .font(.system(size: 15, weight: .medium))
                        
                        Text(context.attributes.time, style: .relative)
                            .monospacedDigit()
                            .font(.system(size: 25, weight: .semibold))
                            .multilineTextAlignment(.trailing)
//                            .minimumScaleFactor(0.1)
//                            .frame(width: 180)
                    }
                    .background(.green)
                }
                .background(.yellow)
                
                ProgressView(timerInterval: Date()...context.attributes.time, countsDown: false)
                    .labelsHidden()
                    .tint(Color(.blueMain))
                    .scaleEffect(y: 4)
                    
            }
            .padding(20)
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Button(action: {}, label: {
                        Image(systemName: "xmark.circle.fill")
                    })
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.attributes.time, style: .relative)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    
                }
            } compactLeading: {
                Image(systemName: "heart")
            } compactTrailing: {
                Text(context.attributes.time, style: .timer)
                    .foregroundStyle(Color(.blueMain))
            } minimal: {
                Image(systemName: "heart")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension LiveActivityWidgetAttributes {
    fileprivate static var preview: LiveActivityWidgetAttributes {
        LiveActivityWidgetAttributes(time: .now.addingTimeInterval(36))
    }
}

#Preview("Notification", as: .content, using: LiveActivityWidgetAttributes.preview) {
   LiveActivityWidgetLiveActivity()
} contentStates: {
    LiveActivityWidgetAttributes.ContentState(products: ["차키", "지갑", "충전기", "지갑", "충전기"])
}
