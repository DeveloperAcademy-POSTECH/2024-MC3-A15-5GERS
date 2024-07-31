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
        NavigationStack {
            ZStack {
                LinearGradient.background.ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("외출 시간을\n등록해 주세요")
                            .font(AppFont.title1)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer().frame(height: 56)
                    
                    Text(homeViewModel.date.timeFormat.koreanFormat)
                        .foregroundStyle(AppColor.gray3)
                        .font(AppFont.body3)
                    
                    Spacer()
                    
                    DatePicker(
                        "", 
                        selection: $viewModel.date,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.wheel)
                    
                    Spacer()
                    
                    Button(action: {
                        
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
                    .padding(.horizontal, 10)
                    .padding(.vertical, 14)
                    .background(AppColor.white1)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(
                        color: .black.opacity(0.15),
                        radius: 20,
                        x: 10,
                        y: 15
                    )
                    
                    Spacer().frame(height: 79)
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        Text("test")
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }

                }
            })
        }
        
    }
}

#Preview {
    SettingView()
        .environment(HomeViewModel())
}
