//
//  model.swift
//  5GERS
//
//  Created by 이정동 on 7/29/24.
//

import Foundation

struct Outing: Codable, Hashable {
    var time: Date
    var products: [String]
}
