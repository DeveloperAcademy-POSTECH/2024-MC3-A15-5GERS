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
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let totalRemainTimerValue: Int = 7200
    @State private var currentRemainTimerValue: Int = 0 {
        didSet {
            let minus = Double(totalRemainTimerValue - min(currentRemainTimerValue, totalRemainTimerValue))
            let div = minus / Double(totalRemainTimerValue)
            
            remainTimerDegreeValue = Int(div * 360)
        }
    }
    @State private var remainTimerDegreeValue: Int = 0
    
    @Binding var outing: Outing
    
    init(outing: Binding<Outing>) {
        self._outing = outing
        
        let value = outing.wrappedValue.time.timeIntervalSinceNow
        self._currentRemainTimerValue = State(initialValue: Int(value))
    }
    
    var body: some View {
        ZStack {
            LinearGradient.background.ignoresSafeArea()
            
            GeometryReader { proxy in
                VStack {
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
                                }
                                Circle()
                                    .frame(width: 70, height: 70)
                                    .foregroundStyle(AppColor.blue)
                                    .overlay {
                                        Image(.logoIcon)
                                    }
                            }
//                            .padding(5)
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
                    outing: $outing,
                    isPresentedProductsEditView: $isPresentedProductsEditView,
                    isInitialMode: false
                )
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                
                Button(action: {
                    isDisplayDeleteAlert = true
                }, label: {
                    Text("취소")
                        .foregroundStyle(AppColor.red)
                })
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(AppColor.blue)
                })
            }
            
        })
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
            let currentValue = Int(outing.time.timeIntervalSinceNow)
            self.currentRemainTimerValue = currentValue
            if currentValue < 0 {
                self.resetOutingData()
            }
        }
        
    }
}

fileprivate struct CircularProgressView: View {
    
    @Binding private var remainTimerDegreeValue: Int
    
    private let proxy: GeometryProxy
    private let outing: Outing
    
    init(
        outing: Outing,
        proxy: GeometryProxy,
        remainTimerDegreeValue: Binding<Int>
    ) {
        self.outing = outing
        self.proxy = proxy
        self._remainTimerDegreeValue = remainTimerDegreeValue
    }
    
    fileprivate var body: some View {
        
        let width = proxy.size.width
        ZStack {
            Image(.timerBackground)
                .resizable()
                .frame(width: width, height: width)
                .shadow(
                    color: .black.opacity(0.1),
                    radius: 20, x: 18, y: 18
                )
                .shadow(
                    color: AppColor.gray1,
                    radius: 20, x: -18, y: -18
                )
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
                                radius: CGFloat(width / 2 - 30),
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
                                radius: CGFloat(width / 2 - 30),
                                startAngle: .degrees(270),
                                endAngle: .degrees(Double(remainTimerDegreeValue - 90)),
                                clockwise: true
                            )
                            
                        }
                        .fill(
                            AngularGradient(
                                colors: remainTimerDegreeValue < 270
                                ? [AppColor.blue.opacity(0.3), AppColor.blue]
                                : [AppColor.red.opacity(0.3), AppColor.red],
                                center: .center,
                                startAngle: .degrees(-90),
                                endAngle: .degrees(270)
                            )
                            
                        )
                        
                    }
                }
            
            Circle()
                .background(.ultraThinMaterial)
                .foregroundColor(.white.opacity(0.1))
                .frame(width: width * (3/5), height: width * (3/5))
                .cornerRadius(width * (3/5) / 2)
                .shadow(radius: 3)
        }
        
    }
}

// MARK: - Function
extension TimerView {
    private func resetOutingData() {
        // UserDefaults 설정
        UserDefaultsManager.shared.setOutingData(.init(time: .now, products: []))
        UserDefaultsManager.shared.setIsTodayAfter(false)
        
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
                
                self.activityButtonState = "실시간 현황을 활성화 하였습니다."
            } else {
                self.activityButtonState = "이미 실시간 현황을 활성화 하였습니다."
            }
        }
    }
}

#Preview {
    TimerView(outing: .constant(.init(time: .now, products: [])))
}
