//
//  TimerView.swift
//  5GERS
//
//  Created by 이정동 on 7/30/24.
//

import SwiftUI



struct TimerView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(HomeViewModel.self) private var viewModel
    @AppStorage(UserDefaultsKey.isTodayAfter) var isTodayAfter: Bool = false
    @State private var isDisplayDeleteAlert: Bool = false
    
    
    
    var body: some View {
        ZStack {
            LinearGradient.background.ignoresSafeArea()
            
            VStack {
                HStack(spacing: 0) {
                    Text("\(viewModel.outing.time.koreanTime)")
                        .foregroundStyle(AppColor.blue)
                    
                    Text(" 까지")
                        .foregroundStyle(AppColor.gray4)
                }
                .font(AppFont.body3)
                .padding(.top, 40)
                
                Text(viewModel.outing.time, style: .timer)
                    .monospacedDigit()
                    .font(AppFont.largeTitle)
                    .foregroundStyle(AppColor.black)
                
                
                CircularProgressView(viewModel: viewModel)
                
                
                VStack(spacing: 8) {
                    HStack {
                        Text("챙길 물건")
                            .font(AppFont.caption)
                            .foregroundStyle(AppColor.gray5)
                        Spacer()
                    }
                    
                    HStack {
                        if viewModel.outing.products.isEmpty {
                            Text("현재 등록하신 물건이 없습니다.")
                        } else {
                            Text(viewModel.outing.products.joinWithComma())
                        }
                        
                        Spacer()
                        Image(systemName: "pencil")
                    }
                    .font(AppFont.body2)
                    .foregroundStyle(AppColor.black)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 14)
                .background(AppColor.gray1)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .onTapGesture {
                    viewModel.isPresentedProductsView = true
                }
                
                Spacer().frame(height: 28)
                
                Button(action: {
                    if viewModel.isActiveLiveActivity {
                        isDisplayDeleteAlert = true
                    } else {
                        withAnimation {
                            viewModel.liveActivityButtonTapped()
                        }
                    }
                }, label: {
                    HStack {
                        Spacer()
                        Text(
                            viewModel.isActiveLiveActivity
                            ? "외출 준비 중단하기"
                            : "외출 준비 시작하기"
                        )
                        .foregroundStyle(
                            viewModel.isActiveLiveActivity
                            ? AppColor.red
                            : AppColor.white1
                        )
                        Spacer()
                    }
                    .font(AppFont.body2)
                })
                .padding(.vertical, 14)
                .background(
                    viewModel.isActiveLiveActivity
                    ? AppColor.white1
                    : AppColor.blue
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(
                    color: .black.opacity(0.15),
                    radius: 20,
                    x: 10,
                    y: 15
                )
                
            }
            .padding(.horizontal, 24)
            
            if viewModel.isPresentedProductsView {
                ProductsEditView(viewModel: viewModel, isInitialMode: false)
            }
        }
        
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(
                        role: .destructive,
                        action: { viewModel.deleteOutingButtonTapped() },
                        label: { Label("Delete", systemImage: "trash") }
                    )
                    .foregroundStyle(AppColor.red)
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(AppColor.black)
                }
            }
        })
        .onChange(of: scenePhase) { old, new in
            if (old == .background) && (new == .inactive) {
                if isTodayAfter && !viewModel.outing.time.isAfterToday {
                    viewModel.deleteOutingButtonTapped()
                }
            }
        }
        .alert("현재 진행하고 있는 외출 준비를 종료하시겠습니까?", isPresented: $isDisplayDeleteAlert) {
            Button(role: .cancel) {
            } label: {
                Text("취소")
            }
            
            Button(role: .destructive) {
                viewModel.deleteOutingButtonTapped()
            } label: {
                Text("종료")
            }
        }
        
    }
}

fileprivate struct CircularProgressView: View {
    private let viewModel: HomeViewModel
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        GeometryReader { proxy in
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
                                    endAngle: .degrees(Double(viewModel.remainingPercent - 90)),
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
                                    endAngle: .degrees(Double(viewModel.remainingPercent - 90)),
                                    clockwise: true
                                )
                                
                            }
                            .fill(
                                AngularGradient(
                                    colors: viewModel.remainingPercent < 270
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
        .padding(.horizontal, 10)
        .onReceive(timer) { _ in
            let currentValue = Int(viewModel.outing.time.timeIntervalSinceNow)
            self.viewModel.currentRemainingTimeValue = currentValue
            if currentValue < 0 {
                self.viewModel.deleteOutingButtonTapped()
            }
            
        }
    }
    
}

#Preview {
    TimerView()
        .environment(HomeViewModel())
}
