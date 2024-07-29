//
//  CustomShortcuts.swift
//  5GERS
//
//  Created by 이정동 on 7/29/24.
//

import Foundation
import AppIntents

struct CustomShortcuts: AppShortcutsProvider {
    
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: TimeIntent(),
            phrases: [
                "\(.applicationName) 남은 시간 알려줘"
            ],
            shortTitle: "남은시간",
            systemImageName: "heart"
        )
    }
}
