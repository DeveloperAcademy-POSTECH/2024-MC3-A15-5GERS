//
//  Array+Ext.swift
//  5GERS
//
//  Created by 이정동 on 7/31/24.
//

import Foundation

extension Array where Element == String {
    func joinWithComma() -> String {
        if self.isEmpty { return "없음" }
        else { return self.joined(separator: ", ") }
    }
}
