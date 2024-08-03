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
    @Environment(HomeViewModel.self) private var viewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            ForEach(outings, id: \.self) { outing in
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .bottom, spacing: 4) {
                        Text(outing.time.koreanTime)
                            .font(AppFont.body1)
                        
                        Spacer()
                    }
                    
                    
                    Text(outing.products.joinWithComma())
                        .font(AppFont.body3)
                        
                }
                .foregroundStyle(AppColor.black)
                .padding(20)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color(red: 0.09, green: 0.1, blue: 0.14).opacity(0.1), radius: 15, x: 10, y: 15)
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .navigationBarTitle(Text("외출 목록"))
        
//        ZStack {
//            NavigationLink(destination: Text("test")) {
//                VStack(alignment: .leading, spacing: 8){
//                    HStack(alignment: .bottom, spacing: 4) {
//                        Text("오후")
//                            .font(.system(size: 20, weight: .regular))
//                        Text("12:30")
//                            .font(.system(size: 42, weight: .regular))
//                    }
//                    Text("에어팟, 지갑, 차키")
//                        .font(.system(size: 17, weight: .regular))
//                    
//                }
//                .frame(width:345, alignment: .leading)
//                .padding()
//                .background(Color.white)
//                .cornerRadius(15)
//                .shadow(color: Color(red: 0.09, green: 0.1, blue: 0.14).opacity(0.1), radius: 15, x: 10, y: 15)
//                
//            }
//            
//            .navigationBarTitle(Text("알람 목록"))
//        }
    }
}

#Preview {
    HistoryView()
        .environment(HomeViewModel())
}
