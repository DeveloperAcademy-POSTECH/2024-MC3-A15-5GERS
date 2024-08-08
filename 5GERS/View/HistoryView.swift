//
//  HistoryView.swift
//  5GERS
//
//  Created by 이정동 on 8/3/24.
//

import SwiftUI
import SwiftData

struct HistoryView : View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \OutingSD.time, order: .forward) var outings: [OutingSD]
    
    @State private var isDisplaySetAlert: Bool = false
    @State private var selectedOutingIndex: Int = 0
    
    var outing: Outing
    
    var body: some View {
        
        ZStack {
            LinearGradient.background.ignoresSafeArea()
            
            VStack {
                ZStack {
                    HStack {
                        Button(action: { dismiss() }, label: {
                            Text("닫기")
                        })
                        Spacer()
                    }
                    Text("외출 목록")
                        .font(AppFont.body2)
                        .foregroundStyle(AppColor.black)
                }
                .padding(.vertical)
                
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(
                            Array(outings.enumerated()),
                            id: \.element
                        ) { idx, outing in
                            Button(
                                action: {
                                    self.selectedOutingIndex = idx
                                    self.isDisplaySetAlert = true
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
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(AppColor.white2)
                                            .shadow(color: AppColor.black.opacity(0.2), radius: 3, x: 5, y: 5)
                                    )
                                    .padding(8)
                                    
                                }
                            )
                            
                        }
                        
                        Spacer()
                    }
                    
                    .alert(
                        "이대로 외출 시간을 설정하시겠습니까?",
                        isPresented: self.$isDisplaySetAlert) {
                            Button(
                                action: {
                                    let outing = self.outings[self.selectedOutingIndex]
                                    self.setOuting(outing)
                                    
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
            .padding(.horizontal, 24)
        }
    }
}

extension HistoryView {
    private func setOuting(_ outing: OutingSD) {
        let new = outing.toEntity()
        
        self.outing.time = new.time.timeFormat
        self.outing.products = new.products
        
        UserDefaultsManager.shared.setOuting(self.outing)
        NotificationManager.shared.scheduleAllAlarmNotification(self.outing)
    }
}

#Preview {
    HistoryView(outing: .init(time: .now, products: []))
}
