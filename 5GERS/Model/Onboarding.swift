//
//  Onboarding.swift
//  5GERS
//
//  Created by 이정동 on 8/12/24.
//

import Foundation

enum Onboarding: CaseIterable {
  case start
  case product
  case liveActivity
  case siri
  
  struct Content {
    enum Extension {
      case gif
      case image
    }
    
    var image: String
    var title: String
    var description: String
    var `extension`: Extension
  }
  
  var value: Self.Content {
    switch self {
    case .start:
        .init(
          image: "onboarding-start",
          title: "외출준비 시작하기",
          description: "지금 몇 시지? 언제까지 나가야 하더라?\n'지금당장'은 옆에서 대답해 줄 친구가 되어드릴게요.",
          extension: .image
        )
    case .product:
        .init(
          image: "onboarding-product",
          title: "깜빡하고 잊는 물건!",
          description: "아 카드! 아 차 키!\n까먹고 다시 집으로 돌아오진 않으신가요?\n나가기 전에 다시 한번 확인해요.",
          extension: .image
        )
    case .liveActivity:
        .init(
          image: "onboarding-liveactivity",
          title: "실시간으로 확인",
          description: "이제 나갈 시간까지 진짜 얼마 안 남았다!\n얼마나 남았는지 휴대폰을 켜지 않아도\n바로 확인할 수 있어요.",
          extension: .image
        )
    case .siri:
        .init(
          image: "onboarding-siri1",
          title: "시리와 함께!",
          description: "시리야, 외출 시간까지 얼마나 남았어?\n시리야, 나 뭐 챙겨야 해?\n앱을 켜지 않아도 시리만 부르면 도와줄 거에요.",
          extension: .image
        )
    }
  }
}
