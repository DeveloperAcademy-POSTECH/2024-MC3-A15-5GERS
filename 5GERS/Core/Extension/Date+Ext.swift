//
//  Date+Ext.swift
//  5GERS
//
//  Created by 이정동 on 7/29/24.
//

import Foundation

extension Date {
    // M월 d일 EEE
    var koreanFormat: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 (E)"
        return formatter.string(from: self)
    }
    
    // 현재 시간으로부터 남은 시간을 리턴
    var remainingTimeFromNow: String {
        let remain = Int(self.timeIntervalSinceNow)

        if remain < 3600 {
            return "\(remain / 60)분"
        } else {
            return "\(remain / 3600)시간 \(remain / 60 % 60)분"
        }
    }
    
    func isAfterToday() -> Bool {
        self > .now ? true : false
    }
}
