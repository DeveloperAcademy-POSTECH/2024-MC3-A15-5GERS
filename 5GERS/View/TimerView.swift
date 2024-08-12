//
//  TimerView.swift
//  5GERS
//
//  Created by 이정동 on 7/30/24.
//

import SwiftUI

struct TimerView: View {
  @Environment(\.scenePhase) private var scenePhase
  @AppStorage(UserDefaultsKey.isTodayAfter) var isTodayAfter: Bool = false
  
  @State var isPresentedProductsEditView: Bool = false
  @State private var isDisplayDeleteAlert: Bool = false
  @State private var isActivityButtonTapped: Bool = false
  @State private var activityButtonState: String = ""
  @State private var isPresentedInfoView: Bool = false
  
  let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
  let totalRemainTimerValue: Double = 7200
  @State private var currentRemainTimerValue: Double = 0 {
    didSet {
      let minus = totalRemainTimerValue - min(currentRemainTimerValue, totalRemainTimerValue)
      let div = minus / totalRemainTimerValue
      
      remainTimerDegreeValue = div * 360
    }
  }
  @State private var remainTimerDegreeValue: Double = 0
  
  @Binding var outing: Outing
  
  init(outing: Binding<Outing>) {
    self._outing = outing
    
    let value = outing.wrappedValue.time.timeIntervalSinceNow
    self._currentRemainTimerValue = State(initialValue: value)
  }
  
  var body: some View {
    ZStack {
      LinearGradient.background.ignoresSafeArea()
      
      GeometryReader { proxy in
        VStack {
          HStack {
            Button(action: {
              isDisplayDeleteAlert = true
            }, label: {
              Text("취소")
                .foregroundStyle(AppColor.red)
                .font(.custom(Pretendard.regular, size: 20))
            })
            Spacer()
            Button(action: {
              isPresentedInfoView = true
            }, label: {
              Image(systemName: "info.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundStyle(AppColor.blue)
            })
          }
          .padding(.vertical, 10)
          
          HStack(spacing: 0) {
            Text("\(outing.time.koreanTime)")
              .foregroundStyle(AppColor.blue)
            
            Text(" 까지")
              .foregroundStyle(AppColor.gray4)
          }
          .font(AppFont.body3)
          .padding(.top, 40)
          
          Text(outing.time, style: .timer)
            .monospacedDigit()
            .font(AppFont.largeTitle)
            .foregroundStyle(AppColor.black)
          
          Text("남았습니다.")
            .font(AppFont.body3)
            .foregroundStyle(AppColor.gray4)
          
          CircularProgressView(
            outing: outing,
            proxy: proxy,
            remainTimerDegreeValue: $remainTimerDegreeValue
          )
          
          HStack {
            Spacer()
            Button(action: {
              self.liveActivityButtonTapped()
              withAnimation {
                self.isActivityButtonTapped = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                  withAnimation {
                    self.isActivityButtonTapped = false
                  }
                }
              }
              
            }, label: {
              HStack {
                if self.isActivityButtonTapped {
                  Text(self.activityButtonState)
                    .foregroundStyle(AppColor.white1)
                    .padding(.leading, 20)
                    .multilineTextAlignment(.trailing)
                }
                Circle()
                  .frame(width: 70, height: 70)
                  .foregroundStyle(AppColor.blue)
                  .overlay {
                    Image(.logoIcon)
                  }
              }
              .background(AppColor.blue)
              .clipShape(RoundedRectangle(cornerRadius: 35))
              
            })
          }
          
          
          Spacer().frame(height: 27)
          
          VStack(spacing: 8) {
            HStack {
              Text("챙길 물건")
              Spacer()
              Image(systemName: "chevron.right")
            }
            .font(AppFont.caption)
            .foregroundStyle(AppColor.gray5)
            
            HStack {
              
              Text(outing.products.joinWithComma())
              
              Spacer()
            }
            .font(AppFont.body2)
            .foregroundStyle(AppColor.black)
          }
          .padding(.vertical, 20)
          .padding(.horizontal, 14)
          .background(AppColor.gray1)
          .clipShape(RoundedRectangle(cornerRadius: 15))
          .onTapGesture {
            self.isPresentedProductsEditView = true
          }
          
          Spacer()
        }
      }
      .padding(.horizontal, 24)
      
      if self.isPresentedProductsEditView {
        ProductsEditView(
          outing: outing,
          isPresentedProductsEditView: $isPresentedProductsEditView,
          isInitialMode: false
        )
      }
    }
    .onChange(of: scenePhase) { old, new in
      if (old == .background) && (new == .inactive) {
        if isTodayAfter && !outing.time.isAfterToday {
          self.resetOutingData()
        }
      }
    }
    .alert(
      "현재 진행하고 있는 외출 준비를 종료하시겠습니까?",
      isPresented: $isDisplayDeleteAlert
    ) {
      Button(role: .cancel) {
      } label: {
        Text("취소")
      }
      
      Button(role: .destructive) {
        self.resetOutingData()
      } label: {
        Text("종료")
      }
    }
    .onReceive(timer) { _ in
      let currentValue = outing.time.timeIntervalSinceNow
      self.currentRemainTimerValue = currentValue
      if currentValue < 0 {
        self.resetOutingData()
      }
    }
    .sheet(isPresented: $isPresentedInfoView, content: {
      InformationView()
        .presentationDetents([.fraction(0.7)])
    })
  }
}


// MARK: - CircularProgressView
fileprivate struct CircularProgressView: View {
  
  @Binding private var remainTimerDegreeValue: Double
  
  private let proxy: GeometryProxy
  private let outing: Outing
  
  init(
    outing: Outing,
    proxy: GeometryProxy,
    remainTimerDegreeValue: Binding<Double>
  ) {
    self.outing = outing
    self.proxy = proxy
    self._remainTimerDegreeValue = remainTimerDegreeValue
  }
  
  fileprivate var body: some View {
    
    let width = proxy.size.width
    ZStack {
      ZStack {
        Circle()
          .frame(width: width * 0.9, height: width * 0.9)
          .foregroundStyle(
            AppColor.lightBlue
              .shadow(
                .inner(
                  color: AppColor.white1,
                  radius: 15, x: -5, y: -5)
              )
              .shadow(
                .inner(
                  color: AppColor.black.opacity(0.1),
                  radius: 15, x: 5, y: 5)
              )
          )
          .shadow(
            color: AppColor.black.opacity(0.3),
            radius: 10, x: 5, y: 5
          )
          .modifier(InnerShadowModifier(radius: width * 0.45))
        Image(.circleDot)
          .resizable()
          .frame(width: width, height: width)
      }
      .overlay {
        ZStack {
          Path { path in
            
            // 포인터 이동
            path.move(
              to: CGPoint(
                x: width / 2,
                y: width / 2
              )
            )
            
            path.addArc(
              center: .init(
                x: width / 2,
                y: width / 2
              ),
              radius: CGFloat(width / 2 - 35),
              startAngle: .degrees(270),
              endAngle: .degrees(Double(remainTimerDegreeValue - 90)),
              clockwise: true
            )
            
          }
          .fill(.white)
          
          Path { path in
            
            // 포인터 이동
            path.move(
              to: CGPoint(
                x: width / 2,
                y: width / 2
              )
            )
            
            path.addArc(
              center: .init(
                x: width / 2,
                y: width / 2
              ),
              radius: CGFloat(width / 2 - 35),
              startAngle: .degrees(270),
              endAngle: .degrees(Double(remainTimerDegreeValue - 90)),
              clockwise: true
            )
            
          }
          .fill(
            AngularGradient(
              colors: remainTimerDegreeValue < 270
              ? [AppColor.angularBlueStart, AppColor.angularBlueEnd]
              : [AppColor.angularRedStart, AppColor.angularRedEnd],
              center: .center,
              startAngle: .degrees(-90),
              endAngle: .degrees(270)
            )
            
          )
          
        }
      }
      
      Circle()
        .background(BlurView(style: .systemThinMaterialLight))
      
      //                .fill(AppColor.white1.opacity(0.5))
        .foregroundStyle(AppColor.white1.opacity(0.5))
      //                .foregroundStyle(.clear)
        .blur(radius: 20)
        .frame(width: width * 0.6, height: width * 0.6)
      
        .cornerRadius(width * 0.6 / 2)
        .shadow(
          color: AppColor.white1.opacity(0.3),
          radius: 20, x: 0, y: 0
        )
      //            AppColor.white1.opacity(0.5)
      //                .frame(width: width * 0.6, height: width * 0.6)
      //                .clipShape(Circle())
      //                .blur(radius: 5)
    }
    
  }
}


// MARK: - InformationView
fileprivate struct InformationView: View {
  
  fileprivate var body: some View {
    
    ZStack {
      LinearGradient.background.ignoresSafeArea()
      
      HStack {
        VStack(alignment: .leading) {
          Text("사용설명서")
            .font(AppFont.title1)
          
          Spacer().frame(height: 50)
          
          
          Text("1. 시리와 함께 준비해요.")
            .foregroundStyle(AppColor.blue)
            .font(AppFont.title2)
          
          Spacer().frame(height: 10)
          Text("\"시리야, [지금당장] 남은 외출시간 알려줘.\"\n시리를 부르고 궁금한 것을 물어본 다음 '지금당장'을 불러주세요. 휴대폰을 만지지 않아도 '지금당장'이 알려드릴게요")
            .foregroundStyle(AppColor.gray4)
            .font(.custom(Pretendard.medium, size: 15))
            .lineSpacing(5)
          
          Spacer().frame(height: 20)
          
          VStack(alignment: .leading, spacing: 5) {
            Group {
              Text("현재 확인 가능한 서비스")
              Text(" - 외출시간까지 남은 시간 확인")
              Text(" - 기입해 둔 소지품 확인")
            }
            .font(.custom(Pretendard.semiBold, size: 15))
            .foregroundStyle(AppColor.gray5)
          }
          
          Spacer().frame(height: 20)
          
          Text("2. 실시간 준비 체크하기")
            .foregroundStyle(AppColor.blue)
            .font(AppFont.title2)
          
          Spacer().frame(height: 10)
          
          Text("아래 버튼을 눌러 잠금화면에서도 실시간으로 남은 시간과 소지품을 확인할 수 있어요.")
            .foregroundStyle(AppColor.gray4)
            .font(.custom(Pretendard.medium, size: 15))
            .lineSpacing(5)
          
          Spacer().frame(height: 20)
          
          Image("logo-icon-color")
            .resizable()
            .frame(width: 50, height: 50)
          
          Spacer()
        }
        
        Spacer()
      }
      .padding(20)
    }
  }
}


// MARK: - Function
extension TimerView {
  private func resetOutingData() {
    // UserDefaults 설정
    UserDefaultsManager.shared.setOuting(nil)
    // Notification 설정
    NotificationManager.shared.removeAllAlarmNotification()
    
    // LiveActivity 설정
    Task { await LiveActivityManager.shared.endActivity() }
    
    self.outing = .init(time: .now, products: [])
  }
  
  private func liveActivityButtonTapped() {
    if self.outing.time.timeIntervalSinceNow > 7200 {
      self.activityButtonState = "외출 2시간 전부터 실시간 현황을 활성화 할 수 있습니다."
    } else {
      let isActivity = LiveActivityManager.shared.isActivateActivity()
      
      if !isActivity {
        try? LiveActivityManager.shared.startActivity(outing)
        NotificationManager.shared.removeLiveActivityNotification()
        
        self.activityButtonState = "실시간 현황을 활성화 하였습니다.\n잠금화면에서 바로 확인해 보세요."
      } else {
        self.activityButtonState = "이미 실시간 현황을 활성화 하였습니다."
      }
    }
  }
}


#Preview {
  TimerView(outing: .constant(.init(time: .now, products: [])))
  //  InformationView()
}
