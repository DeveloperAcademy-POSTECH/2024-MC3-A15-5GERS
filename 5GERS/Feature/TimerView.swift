//
//  TimerView.swift
//  5GERS
//
//  Created by 이정동 on 7/30/24.
//

import SwiftUI



struct TimerView: View {
    @Environment(HomeViewModel.self) private var viewModel
    
    var body: some View {
        ZStack {
            LinearGradient.background.ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("외출 준비 중")
                        .font(AppFont.title1)
                        .foregroundStyle(AppColor.black)
                    Spacer()
                }
                
                Text("01:40:32")
                    .font(AppFont.largeTitle)
                    .foregroundStyle(AppColor.black)
                    .padding(.top, 40)
                
                Text("오전 12:30 까지")
                    .font(AppFont.body3)
                    .foregroundStyle(AppColor.gray4)
                
                Spacer()
                
                VStack(spacing: 8) {
                    HStack {
                        Text("챙길 물건")
                            .font(AppFont.caption)
                            .foregroundStyle(AppColor.gray5)
                        Spacer()
                    }
                    
                    HStack {
                        Text("휴대폰, 에어팟, 지갑, 차키")
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
                
                Spacer().frame(height: 28)
                
                Button(action: {
                    withAnimation {
                        viewModel.isPresentedProductsView = true
                    }
                }, label: {
                    HStack {
                        Spacer()
                        Text("외출 준비 시작하기")
                            .foregroundStyle(AppColor.white1)
                        Spacer()
                    }
                    .font(AppFont.body2)
                })
                .padding(.vertical, 14)
                .background(AppColor.blue)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(
                    color: .black.opacity(0.15),
                    radius: 20,
                    x: 10,
                    y: 15
                )
                
                Spacer().frame(height: 79)
            }
            .padding(.horizontal, 24)
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(
                        action: {
                            print("Delete")
                        }, label: {
                            Label("Delete", systemImage: "trash")
                                .foregroundStyle(AppColor.red)
                    })
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(AppColor.black)
                }
            }
        })
    }
}

#Preview {
    TimerView()
        .environment(HomeViewModel())
}
