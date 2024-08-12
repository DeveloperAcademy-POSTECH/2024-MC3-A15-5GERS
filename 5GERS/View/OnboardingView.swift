//
//  OnboardingView.swift
//  5GERS
//
//  Created by 이정동 on 8/12/24.
//

import SwiftUI

struct OnboardingView: View {
  
  @State private var selectedTab: Int = 0
  
  init() {
    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(resource: .blueMain)
    UIPageControl.appearance().pageIndicatorTintColor = UIColor(resource: .blueMain).withAlphaComponent(0.3)
  }
  
  var body: some View {
    VStack {
      TabView(selection: $selectedTab,
              content:  {
        ForEach(Array(Onboarding.allCases.enumerated()), id: \.element) { index, onboarding in
          OnboardingContentView(content: onboarding.value)
            .tag(index)
        }
      })
      .tabViewStyle(.page(indexDisplayMode: .always))
      
      Spacer().frame(height: 30)
      
      Button(action: {
        if selectedTab < Onboarding.allCases.count - 1 {
          withAnimation {
            selectedTab += 1
          }
          
        } else {
          print("End")
        }
      }, label: {
        Text(selectedTab != (Onboarding.allCases.count - 1) ? "다음" : "시작하기")
          .frame(width: 150, height: 50)
          .background(AppColor.blue)
          .foregroundStyle(AppColor.white1)
          .font(.custom(Pretendard.semiBold, size: 18))
          .clipShape(RoundedRectangle(cornerRadius: 15))
      })
      
      
      Spacer().frame(height: 30)
    }
    
    
  }
}

fileprivate struct OnboardingContentView: View {
  private let content: Onboarding.Content
  
  init(content: Onboarding.Content) {
    self.content = content
  }
  
  fileprivate var body: some View {
    VStack {
      Spacer().frame(height: 100)
      
      if content.extension == .gif {
        GifImage(content.image)
          .aspectRatio(1, contentMode: .fit)
        
      } else {
        Image(content.image)
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(width: 300, height: 300)
      }
      
      
      Text(content.title)
        .font(AppFont.title1)
        .foregroundStyle(AppColor.black)
      
      Spacer().frame(height: 15)
      Text(content.description)
        .font(AppFont.body3)
        .foregroundStyle(AppColor.black)
        .multilineTextAlignment(.center)
        .lineSpacing(3)
      
      Spacer()
    }
  }
}


#Preview {
  OnboardingView()
}
