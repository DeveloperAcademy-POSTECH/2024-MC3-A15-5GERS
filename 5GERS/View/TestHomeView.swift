////
////  ContentView.swift
////  5GERS
////
////  Created by 이정동 on 7/29/24.
////
//
//import SwiftUI
//
//struct TestHomeView: View {
//    @AppStorage("outing") private var out: Data?
//    @State private var outing: Outing?
//    
//    var body: some View {
//        
//            VStack {
//                if let data = outing,
//                   data.time.isAfterToday() {
//                    MainView()
//                } else {
//                    InitView()
//                }
//            }
//        
////        .onAppear {
////            self.outing = UserDefaultsManager.shared.getOutingData()
////        }
//        .onChange(of: out, initial: true) { oldValue, newValue in
//            if let data = newValue,
//                let decodedData = try? JSONDecoder().decode(Outing.self, from: data) {
//                outing = decodedData
//            } else {
//                outing = nil
//            }
//        }
//        
//    }
//}
//
//fileprivate struct InitView: View {
//    @State private var time: Date = .now
//    @State private var isSheet: Bool = false
//    
//    fileprivate var body: some View {
//        NavigationStack {
//            VStack {
//                Text("\(time.timeFormat.koreanFormat)")
//                DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
//                    .datePickerStyle(.wheel)
//                
//                Button {
//                    isSheet = true
//                } label: {
//                    Text("소지품 추가")
//                }
//
//            }
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    NavigationLink {
//                        
//                    } label: {
//                        Image(systemName: "clock.arrow.circlepath")
//                    }
//
//                }
//            }
//            .sheet(isPresented: $isSheet, content: {
//                ProductsView(newOuting: Outing(time: time.timeFormat, products: []))
//            })
//        }
//        
//    }
//}
//
//fileprivate struct ProductsView: View {
//    @State private var products: [String]
//    var newOuting: Outing
//    
//    init(newOuting: Outing) {
//        
//        self.newOuting = newOuting
//        self._products = State(initialValue: newOuting.products)
//    }
//    
//    fileprivate var body: some View {
//        VStack {
//            ForEach(products, id: \.self) { product in
//                Text("\(product)")
//            }
//            Button(action: {
//                products.append("카드")
//            }, label: {
//                Text("Add")
//            })
//            
//            Button(action: {
//                
//                UserDefaultsManager.shared.setOutingData(Outing(time: newOuting.time, products: products))
//                
//                NotificationManager.shared.scheduleAlarmNotification(at: newOuting.time.addingTimeInterval(-5))
//            }, label: {
//                Text("Done")
//            })
//        }
//    }
//}
//
//fileprivate struct MainView: View {
//    @AppStorage("outing") private var out: Data?
//    @State private var outing: Outing?
//    
//    fileprivate var body: some View {
//        VStack {
//            Button(action: {
//                UserDefaultsManager.shared.removeOutingData()
//                NotificationManager.shared.removeAllAlarmNotification()
//            }, label: {
//                Text("Delete")
//                
//                
//            })
//            
//            Text(outing?.time ?? Date(), style: .timer)
//            
//            Button(action: {
//                try? LiveActivityManager.shared.startActivity(outing?.time ?? .now)
//                
//                SwiftDataManager.shared.create(outing ?? Outing(time: .now, products: ["test"]))
//                print(SwiftDataManager.shared.fetch())
//            }, label: {
//                Text("Start")
//            })
//        }
//        .onAppear {
//            if let data = out,
//                let decodedData = try? JSONDecoder().decode(Outing.self, from: data) {
//                outing = decodedData
//            }
//        }
//    }
//}
//
//#Preview {
//    TestHomeView()
//}
