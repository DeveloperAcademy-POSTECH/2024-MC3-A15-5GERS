//
//  LiveActivityWidgetLiveActivity.swift
//  LiveActivityWidget
//
//  Created by 이정동 on 7/29/24.
//

import ActivityKit
import WidgetKit
import SwiftUI
import AppIntents

struct LiveActivityWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var products: [String]
    }
    
    var time: Date
}

struct LiveActivityWidgetLiveActivity: Widget {
    @Environment(\.colorScheme) private var colorScheme
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityWidgetAttributes.self) { context in
            
            VStack(spacing: 10) {
                
                HStack(alignment: .firstTextBaseline) {
                    Text("챙길 소지품")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color(.blueMain))
                    Spacer().frame(width: 20)
                    Spacer()
                    Text(context.state.products.joinWithComma())
                        .lineLimit(1)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(AppColor.white1)
                    
                }
                
                HStack(alignment: .lastTextBaseline) {
                    Text("외출까지")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color(.blueMain))
                    Text(context.attributes.time, style: .relative)
                        .multilineTextAlignment(.trailing)
                        .font(.system(size: 45, weight: .semibold))
                        .foregroundStyle(AppColor.white1)
                }
                
                HStack {
                    ProgressView(timerInterval: context.attributes.time.addingTimeInterval(-7200)...context.attributes.time, countsDown: true)
                        .labelsHidden()
                        .scaleEffect(y: 1.5)
                }
                
                    
            }
            .padding(20)
            .activityBackgroundTint(AppColor.black.opacity(0.8))
            .activitySystemActionForegroundColor(AppColor.white1)
            
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Button(intent: LiveActivityDeleteIntent()) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                    }
                    
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Spacer()
                        Text(context.attributes.time, style: .relative)
                            .multilineTextAlignment(.trailing)
                            .font(.system(size: 25, weight: .semibold))
                            .frame(width: 130, height: 40)
                    }
                    
                }
                DynamicIslandExpandedRegion(.bottom) {
                }
            } compactLeading: {
                Image("logo-icon-color")
                    .resizable()
                    .frame(width: 25, height: 25)
            } compactTrailing: {
                Text(context.attributes.time, style: .relative)
                    .frame(width: 70)
                    .foregroundStyle(Color(.blueMain))
                    .multilineTextAlignment(.trailing)
            } minimal: {
                Image("logo-icon-color")
                    .resizable()
                    .frame(width: 25, height: 25)
            }
            .keylineTint(Color.red)
        }
    }
}

extension LiveActivityWidgetAttributes {
    fileprivate static var preview: LiveActivityWidgetAttributes {
        LiveActivityWidgetAttributes(time: .now.addingTimeInterval(3600))
    }
}



#Preview("Notification", as: .content, using: LiveActivityWidgetAttributes.preview) {
    LiveActivityWidgetLiveActivity()
} contentStates: {
    LiveActivityWidgetAttributes.ContentState(products: ["차키", "지갑", "충전기", "지갑", "충전기", "지갑", "충전기"])
}
