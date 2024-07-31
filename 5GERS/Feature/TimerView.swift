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
        
        VStack {
            HStack {
                Text("외출 준비 중")
                    .font(AppFont.title1)
                    .foregroundStyle(AppColor.black)
                Spacer()
            }
            
            Text(viewModel.outing.time, style: .timer)
                .monospacedDigit()
                .font(AppFont.largeTitle)
                .foregroundStyle(AppColor.black)
                .padding(.top, 40)
            
            Text("\(viewModel.outing.time.koreanTime) 까지")
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
                withAnimation {
                    viewModel.liveActivityButtonTapped()
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
            
            Spacer().frame(height: 79)
        }
        .padding(.horizontal, 24)
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
    }
}

#Preview {
    TimerView()
        .environment(HomeViewModel())
}
