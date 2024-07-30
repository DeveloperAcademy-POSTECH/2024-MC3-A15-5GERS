//
//  Font.swift
//  5GERS
//
//  Created by 이정동 on 7/30/24.
//

import Foundation
import SwiftUI

struct Pretendard {
    static let black = "Pretendard-Black"
    static let bold = "Pretendard-Bold"
    static let extraBold = "Pretendard-ExtraBold"
    static let extraLight = "Pretendard-ExtraLight"
    static let light = "Pretendard-Light"
    static let medium = "Pretendard-Medium"
    static let regular = "Pretendard-Regular"
    static let semiBold = "Pretendard-SemiBold"
    static let thin = "Pretendard-Thin"
}

struct AppFont {
    // Title
    static let largeTitle: Font = .custom(Pretendard.semiBold, size: 47)
    static let title1: Font = .custom(Pretendard.semiBold, size: 28)
    static let title2: Font = .custom(Pretendard.semiBold, size: 17)
    
    // Body
    static let body1: Font = .custom(Pretendard.medium, size: 42)
    static let body2: Font = .custom(Pretendard.medium, size: 20)
    static let body3: Font = .custom(Pretendard.regular, size: 17)
    static let caption: Font = .custom(Pretendard.regular, size: 11)
}
