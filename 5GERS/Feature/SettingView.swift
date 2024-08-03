//
//  SettingView.swift
//  5GERS
//
//  Created by 이정동 on 7/30/24.
//

import SwiftUI

struct SettingView: View {
    @Environment(HomeViewModel.self) private var homeViewModel
    
    var body: some View {
        @Bindable var viewModel = homeViewModel
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
                
                Text(homeViewModel.outing.time.timeFormat.koreanDate)
                    .foregroundStyle(AppColor.gray4)
                    .font(AppFont.body3)
                
                Spacer()
                
                DatePicker(
                    "", 
                    selection: $viewModel.outing.time,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .foregroundStyle(AppColor.black)
                
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        viewModel.isPresentedProductsView = true
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
            
            if viewModel.isPresentedProductsView {
                ProductsEditView(viewModel: viewModel, isInitialMode: true)
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    Text("test")
                } label: {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundStyle(.black)
                }
            }
        })
    }
}

#Preview {
    SettingView()
        .environment(HomeViewModel())
}
