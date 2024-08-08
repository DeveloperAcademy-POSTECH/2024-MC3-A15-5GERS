//
//  Color.swift
//  5GERS
//
//  Created by 이정동 on 7/30/24.
//

import Foundation
import SwiftUI

struct AppColor {
    static let black = Color(.blackMain)
    static let blue = Color(.blueMain)
    static let red = Color(.redMain)
    static let gray1 = Color(.gray1)
    static let gray2 = Color(.gray2)
    static let gray3 = Color(.gray3)
    static let gray4 = Color(.gray4)
    static let gray5 = Color(.gray5)
    static let white1 = Color(.white1)
    static let white2 = Color(.white2)
    
    static let angularRedStart = Color(.angularGradientRedStart)
    static let angularRedEnd = Color(.angularGradientRedEnd)
    static let angularBlueStart = Color(.angularGradientBlueStart)
    static let angularBlueEnd = Color(.angularGradientBlueEnd)
    
}

extension LinearGradient {
    static let background = Self(
        colors: [
            .linearGradientTop,
            .linearGradientBottom
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}
