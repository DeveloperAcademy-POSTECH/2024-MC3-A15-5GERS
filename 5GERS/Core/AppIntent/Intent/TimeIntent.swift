//
//  CustomIntent.swift
//  5GERS
//
//  Created by 이정동 on 7/29/24.
//

import Foundation
import AppIntents


struct TimeIntent: AppIntent {
    static let title: LocalizedStringResource = "남은시간"
    
    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        
        let data = UserDefaultsManager.shared.getOutingData()
        
        if data.time > .now {
            return .result(dialog: "남은시간 \(data.time.convertRemainingTime(from: .now)) 입니다.")
        } else {
            return .result(dialog: "예정된 외출이 없습니다")
        }
    }
}
