//
//  SettingView.swift
//  5GERS
//
//  Created by 이정동 on 7/30/24.
//

import SwiftUI

struct SettingView: View {
    @Binding var outing: Outing
    @State private var isPresentedProductsEditView: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient.background.ignoresSafeArea()
            VStack {
                HStack {
                    Text("외출 시간을\n등록해 주세요")
                        .font(AppFont.title1)
                        .foregroundStyle(AppColor.black)
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                Spacer().frame(height: 56)
                
                Text(outing.time.timeFormat.koreanDate)
                    .foregroundStyle(AppColor.gray4)
                    .font(AppFont.body3)
                
                Spacer()
                
                DatePicker(
                    "", 
                    selection: $outing.time,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .colorInvert()
                .colorMultiply(.black)
//                CircularPickerView()
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        self.isPresentedProductsEditView = true
                    }
                    
                }, label: {
                    HStack {
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundStyle(AppColor.blue)
                        Text("소지품 추가하기")
                            .foregroundStyle(AppColor.black)
                        Spacer()
                    }
                    .font(AppFont.body2)
                })
                .padding(.vertical, 14)
                .background(AppColor.white1)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.horizontal, 20)
                .shadow(
                    color: .black.opacity(0.15),
                    radius: 20,
                    x: 10,
                    y: 15
                )
                
                Spacer().frame(height: 79)
            }
            
            if isPresentedProductsEditView {
                ProductsEditView(
                    outing: $outing,
                    isPresentedProductsEditView: $isPresentedProductsEditView,
                    isInitialMode: true)
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    HistoryView(outing: $outing)
                } label: {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundStyle(.black)
                }
            }
        })
    }
}

fileprivate struct CircularPickerView: View {
    @State private var selectedHour: Int = 6
    @State private var selectedMinute: Int = 30
    
    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 0) {
                CircularPicker(selectedItem: $selectedHour, isReversed: false)
                
                CircularPicker(selectedItem: $selectedMinute, isReversed: true)
            }
            .padding()
        }
    }
}

fileprivate struct CircularPicker: View {
    @State private var activeID: Int?
    @Binding var selectedItem: Int
    
    let items: [Int]
    let isReversed: Bool
    let rowSize: CGSize = CGSize(width: 70, height: 70)
    
    init(selectedItem: Binding<Int>, isReversed: Bool) {
        self.items = isReversed ? Array(0...23) : Array(0...59)
        self._selectedItem = selectedItem
        self.isReversed = isReversed
    }
    
    var body: some View {
        GeometryReader { proxyP in
            
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: proxyP.size.height, height: proxyP.size.height)
                    .position(
                        x: isReversed
                        ? (proxyP.size.width / 2) + proxyP.size.height / 3
                        : (proxyP.size.width / 2) - proxyP.size.height / 3,
                        y: proxyP.size.height / 2
                    )
                    .overlay {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: proxyP.size.height * 0.7, height: proxyP.size.height * 0.7)
                            .position(
                                x: isReversed
                                ? (proxyP.size.width / 2) + proxyP.size.height / 3
                                : (proxyP.size.width / 2) - proxyP.size.height / 3,
                                y: proxyP.size.height / 2
                            )
                            .overlay {
                                Circle()
                                    .fill(Color.white.opacity(0.5))
                                    .frame(width: proxyP.size.height * 0.5, height: proxyP.size.height * 0.5)
                                    .position(
                                        x: isReversed
                                        ? (proxyP.size.width / 2) + proxyP.size.height / 3
                                        : (proxyP.size.width / 2) - proxyP.size.height / 3,
                                        y: proxyP.size.height / 2
                                    )
                            }
                    }
                
                ScrollView {
                    LazyVStack {
                        ForEach(0..<(items.count * 100), id: \.self) { index in
                            GeometryReader { proxyC in
                                let rect = proxyC.frame(in: .named("scroll"))
                                let y = rect.midY
                                let curveX = getCurveValue(y, proxyP.size.height) * rowSize.height - rowSize.height
                                let opacity = getAlphaValue(y, proxyP.size.height)
                                
                                Text(items[index % items.count] / 10 < 1 ? "0\(items[index % items.count])" : "\(items[index % items.count])")
                                    .font(
                                        .system(
                                            size: index % items.count == selectedItem ? 30 : 20,
                                            weight: index % items.count == selectedItem ? .black : .medium
                                        )
                                    )
                                    .frame(width: rowSize.width, height: rowSize.height)
                                    .background(Color.clear)
                                    .opacity(opacity)
                                    .offset(x: isReversed ? -curveX * 2 : curveX * 2)
                                    .rotationEffect(
                                        .degrees(
                                            isReversed
                                            ? -getRotateValue(y, proxyP.size.height) * 20
                                            : getRotateValue(y, proxyP.size.height) * 20),
                                        anchor: .center
                                    )
                                    .id(index)
                                    .onTapGesture {
                                        selectedItem = index % items.count
                                        activeID = index % items.count
                                    }
                            }
                            .frame(width: rowSize.width, height: rowSize.height)
                        }
                    }
                    
                    .offset(x: isReversed ? proxyP.size.width * 0.2 : -proxyP.size.width * 0.2)
                    .scrollTargetLayout()
                }
                .safeAreaPadding(.vertical, (proxyP.size.height - 70) / 2)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $activeID)
                .coordinateSpace(name: "scroll")
                
            }
            
        }
        .onAppear {
            self.activeID = selectedItem + (items.count * 50)
        }
        .onChange(of: activeID) { oldValue, newValue in
            selectedItem = (activeID ?? 0) % items.count
        }
        
    }
    
    private func getAlphaValue(_ current: Double, _ total: Double) -> CGFloat {
        let x = Double(current) / Double(total)
        let y = (sin(-1.0 * (.pi * x) - .pi / 1))
        return CGFloat(y)
    }
    
    private func getCurveValue(_ current: Double, _ total: Double) -> CGFloat {
        let x = Double(current) / Double(total)
        let y = (sin(-1 * .pi * x - .pi) + 0.5) / 2
        return 2 * CGFloat(y)
    }
    
    private func getRotateValue(_ current: Double, _ total: Double) -> CGFloat {
        let x = Double(current) / Double(total)
        let y = (sin(.pi * x - (.pi / 2.0))) / 2.0
        return 2 * CGFloat(y)
    }
}

#Preview {
    SettingView(outing: .constant(.init(time: .now, products: [])))
}
