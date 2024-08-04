//
//  HistoryView.swift
//  5GERS
//
//  Created by 이정동 on 8/3/24.
//

import SwiftUI
import SwiftData

struct HistoryView : View {
    @Query(sort: \OutingSD.time, order: .forward) var outings: [OutingSD]
    @Environment(HomeViewModel.self) private var homeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var historyViewModel = HistoryViewModel()
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(
                    Array(historyViewModel.outings.enumerated()),
                    id: \.element
                ) { idx, outing in
                    Button(
                        action: {
                            historyViewModel.selectedOutingIndex = idx
                            historyViewModel.isDisplaySetAlert = true
                        },
                        label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(outing.time.koreanTime)
                                        .font(AppFont.body1)
                                    Text(outing.products.joinWithComma())
                                        .font(AppFont.body3)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .frame(width: 40, height: 40)
                                    .font(AppFont.body2)
                            }
                            .foregroundStyle(AppColor.black)
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(
                                color: AppColor.black.opacity(0.1),
                                radius: 15, x: 10, y: 15
                            )
                        })
                    
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .navigationBarTitle(Text("외출 목록"))
            .alert(
                "이대로 외출 시간을 설정하시겠습니까?",
                isPresented: $historyViewModel.isDisplaySetAlert) {
                    Button(
                        action: {
                            let outing = historyViewModel.outings[historyViewModel.selectedOutingIndex]
                            homeViewModel.setOuting(outing)
                            
                            dismiss()
                        },
                        label: { Text("확인") }
                    )
                    
                    Button(role: .cancel) {
                    } label: {
                        Text("취소")
                    }
                }
        }
    }
}

#Preview {
    HistoryView()
        .environment(HomeViewModel())
}
