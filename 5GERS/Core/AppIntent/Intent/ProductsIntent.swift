//
//  ProductsIntent.swift
//  5GERS
//
//  Created by 이정동 on 7/30/24.
//

import Foundation
import AppIntents


struct ProductsIntent: AppIntent {
    static let title: LocalizedStringResource = "챙길물건"
    
    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        
        let data = UserDefaultsManager.shared.getOutingData()
        
        if data.products.isEmpty {
            return .result(dialog: "챙기실 물건을 등록하지 않았습니다")
        } else {
            var products = "\(data.products[0])"
            (1..<data.products.count).forEach { products += ", \(data.products[$0])"}
            return .result(dialog: "챙기실 물건은 \(products) 입니다.")
        }
    }
}
