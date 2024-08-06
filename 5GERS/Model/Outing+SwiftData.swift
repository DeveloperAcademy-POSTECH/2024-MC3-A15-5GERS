//
//  Outing+SwiftData.swift
//  5GERS
//
//  Created by 이정동 on 7/30/24.
//

import Foundation
import SwiftData

@Model
class OutingSD {
    @Attribute(.unique) var time: Date
    var products: [String]
    
    init(time: Date, products: [String]) {
        self.time = time
        self.products = products
    }
}

extension OutingSD {
    func toEntity() -> Outing {
        Outing(time: self.time, products: self.products)
    }
}
