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
    
    // TODO: 변수 이름 변경
    // 타이머 형식 텍스트
    var timeFormat: Date {
        let calendar = Calendar.current
        var now = Date()
    
        let nowDateComponents = calendar.dateComponents([.hour, .minute], from: now)
        let targetDateComponents = calendar.dateComponents([.hour, .minute], from: self)
        
        let nowMinute = (nowDateComponents.hour! * 60) + (nowDateComponents.minute!)
        let targetMinute = (targetDateComponents.hour! * 60) + (targetDateComponents.minute!)
    
        var components = DateComponents()
        
        if nowMinute <= targetMinute {
            components.year = calendar.component(.year, from: now)
            components.month = calendar.component(.month, from: now)
            components.day = calendar.component(.day, from: now)
            components.hour = targetDateComponents.hour
            components.minute = targetDateComponents.minute
        } else {
            now = now.addingTimeInterval(86400)
            components.year = calendar.component(.year, from: now)
            components.month = calendar.component(.month, from: now)
            components.day = calendar.component(.day, from: now)
            components.hour = targetDateComponents.hour
            components.minute = targetDateComponents.minute
        }
        
        return calendar.date(from: components)!
    }
    
    // 현재보다 이후의 날짜인지 확인
    func isAfterToday() -> Bool {
        self > .now ? true : false
    }
    
    func convertToTimerDate() {
        
    }
}
