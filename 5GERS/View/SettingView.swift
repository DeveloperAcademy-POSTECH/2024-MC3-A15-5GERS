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

#Preview {
    SettingView(outing: .constant(.init(time: .now, products: [])))
}
