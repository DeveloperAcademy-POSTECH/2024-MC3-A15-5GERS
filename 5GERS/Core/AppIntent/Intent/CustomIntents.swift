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
        
        
        return .result(dialog: "남은시간 \(Date().description)", view: HomeView())
    }
}
