//
//  InnerShadowModifier.swift
//  5GERS
//
//  Created by 이정동 on 8/12/24.
//

import SwiftUI

struct InnerShadowModifier: ViewModifier {
  var radius: CGFloat
  
  func body(content:Content) -> some View {
    content
      .overlay(
        RoundedRectangle(cornerRadius: radius)
          .stroke(AppColor.white1, lineWidth :1)
          .shadow(color: AppColor.dark, radius: 8, x: 7, y: 7)
          .shadow(color: AppColor.white1, radius : 8, x: -7, y: -7)
      )
  }
}
