//
//  LiveActivityDeleteIntent.swift
//  5GERS
//
//  Created by 이정동 on 8/3/24.
//

import AppIntents

struct LiveActivityDeleteIntent: AppIntent {
    static let title: LocalizedStringResource = "삭제"
    
    func perform() async throws -> some IntentResult {
        await LiveActivityManager.shared.endActivity()
        return .result()
    }
}
