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
    
    @Binding var outing: Outing
    
    var body: some View {
        
        ZStack {
            LinearGradient.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
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
                .navigationTitle(Text("외출 목록"))
                
                
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
    }
}

extension HistoryView {
    private func setOuting(_ outing: OutingSD) {
        
        
        self.outing = outing.toEntity()

        UserDefaultsManager.shared.setOuting(self.outing)
        NotificationManager.shared.scheduleAllAlarmNotification(self.outing)
    }
}

#Preview {
    HistoryView(outing: .constant(.init(time: .now, products: [])))
}
