//
//  model.swift
//  5GERS
//
//  Created by 이정동 on 7/29/24.
//

import Foundation

@Observable
class Outing: Codable {
    var time: Date = .now
    var products: [String] = []
    
    init(time: Date, products: [String]) {
        self.time = time
        self.products = products
    }
}
