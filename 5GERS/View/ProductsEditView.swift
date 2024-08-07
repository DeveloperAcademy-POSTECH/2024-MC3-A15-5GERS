//
//  ProductsEditView.swift
//  5GERS
//
//  Created by 이정동 on 7/31/24.
//

import Foundation
import SwiftUI
import SwiftData


struct TextFieldItem: Identifiable {
    let id = UUID()
    var text: String
}

struct ProductsEditView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Binding private var outing: Outing
    @Binding private var isPresentedProductsEditView: Bool
    
    @State private var textfieldItems: [TextFieldItem] = []
    
    @FocusState private var focusedField: Int?
    @State private var isDisplayDoneAlert: Bool = false
    let isInitialMode: Bool
    
    init(
        outing: Binding<Outing>,
        isPresentedProductsEditView: Binding<Bool>,
        isInitialMode: Bool
    ) {
        self._outing = outing
        self._isPresentedProductsEditView = isPresentedProductsEditView
        self.isInitialMode = isInitialMode
        
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        ZStack {
            AppColor.black.opacity(0.5).ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        self.isPresentedProductsEditView = false
                    }
                }
            
            HStack {
                Spacer().frame(width: 46)
                
                VStack {
                    HStack {
                        Text("꼭 챙겨야 할 소지품")
                            .foregroundStyle(AppColor.black)
                        Spacer()
                        Button(
                            action: {
                                self.isDisplayDoneAlert = true
                            },
                            label: {
                                Text("완료")
                                    .foregroundStyle(AppColor.blue)
                            })
                    }
                    .font(AppFont.title2)
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    
                    Button(
                        action: {
                            self.addProductButtonTapped()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                focusedField = 0
                            }
                        },
                        label: {
                            HStack {
                                Spacer()
                                Image(systemName: "plus")
                                Text("추가하기")
                            }
                            .font(AppFont.body3)
                            .foregroundStyle(AppColor.gray4)
                            
                        })
                    .padding(.top, 24)
                    .padding(.horizontal, 20)
                    
                    
                    ScrollView {
                        VStack {
                            ForEach(
                                Array($textfieldItems.enumerated()),
                                id: \.element.id
                            ) { idx, product in
                                HStack {
                                    TextField("", text: product.text)
                                        .focused($focusedField, equals: idx)
                                        .id(idx)
                                    
                                    Button(
                                        action: {
                                            self.deleteProductButtonTapped(at: idx)
                                            
                                        }, label: {
                                            Image(systemName: "xmark")
                                        })
                                }
                                .foregroundStyle(AppColor.gray5)
                                .padding(15)
                                .background(AppColor.gray2)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                    }
                    
                    Spacer()
                }
                // TODO: 높이 크기 조정
                .frame(height: 450)
                .background(AppColor.white1)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                Spacer().frame(width: 46)
            }
        }
        .onAppear {
            self.convertToTextfieldItem(outing.products)
        }
        .alert(
            "현재 내용을 저장하시겠습니까?",
            isPresented: self.$isDisplayDoneAlert) {
                Button(role: .cancel) {
                } label: {
                    Text("취소")
                }
                
                Button {
                    self.saveProductsButtonTapped()
                    
                    self.isPresentedProductsEditView = false
                } label: {
                    Text("저장")
                }
            }
    }
}

// MARK: - Function
extension ProductsEditView {
    private func convertToTextfieldItem(_ products: [String]) {
        self.textfieldItems = products.map { TextFieldItem(text: $0) }
    }
    
    private func saveProductsButtonTapped() {
        
        // TODO: products에 빈 문자열이 없는 것만 추가
        self.outing.products = self.textfieldItems.map { $0.text }
        
        self.outing.time = self.outing.time.timeFormat
        
        UserDefaultsManager.shared.setOuting(self.outing)
        if isInitialMode {
            NotificationManager.shared.scheduleAllAlarmNotification(self.outing)
            
            self.insertToSwiftData(outing)
            
        } else {
            // 라이브액티비티 업데이트
            if LiveActivityManager.shared.isActivateActivity() {
                Task { await LiveActivityManager.shared.updateActivity(outing.products) }
            }
            
            self.updateToSwiftData(outing)
        }
    }
    
    private func addProductButtonTapped() {
        self.textfieldItems.insert(.init(text: ""), at: 0)
    }
    
    private func deleteProductButtonTapped(at index: Int) {
        self.textfieldItems.remove(at: index)
    }
    
    private func insertToSwiftData(_ outing: Outing) {
        let model = OutingSD(time: outing.time, products: outing.products)
        modelContext.insert(model)
    }
    
    private func updateToSwiftData(_ outing: Outing) {
        let predicate = #Predicate<OutingSD> { $0.time == outing.time }
        do {
            let datas = try modelContext.fetch(FetchDescriptor(predicate: predicate))
            guard let data = datas.first else { return }
            data.products = outing.products
        } catch {
            print(error.localizedDescription)
        }
    }
}


#Preview {
    ProductsEditView(
        outing: .constant(.init(time: .now, products: [])),
        isPresentedProductsEditView: .constant(true),
        isInitialMode: true
    )
}
