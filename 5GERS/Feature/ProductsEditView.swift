//
//  ProductsEditView.swift
//  5GERS
//
//  Created by 이정동 on 7/31/24.
//

import Foundation
import SwiftUI


struct TextFieldItem: Identifiable {
    let id = UUID()
    var text: String
}

struct ProductsEditView: View {
    @Bindable private var viewModel: HomeViewModel
    @FocusState private var focusedField: Int?
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            AppColor.black.opacity(0.5).ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        viewModel.isPresentedProductsView = false
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
                                viewModel.saveProductsButtonTapped()
                                viewModel.isPresentedProductsView = false
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
                            viewModel.addProductButtonTapped()
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
                            .foregroundStyle(AppColor.black)
                            
                    })
                    .padding(.top, 24)
                    .padding(.horizontal, 20)
                    
                    VStack {
                        ForEach(
                            Array($viewModel.products.enumerated()),
                            id: \.element.id
                        ) { idx, product in
                            HStack {
                                TextField("", text: product.text)
                                    .focused($focusedField, equals: idx)
                                    .id(idx)
                                
                                Button(
                                    action: {
                                        viewModel.deleteProductButtonTapped(at: idx)
                                        
                                    }, label: {
                                        Image(systemName: "xmark")
                                })
                            }
                            .foregroundStyle(AppColor.gray3)
                            .padding(15)
                            .background(AppColor.gray1)
                            
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    
                    Spacer()
                }
                // TODO: 높이 크기 조정
                .frame(height: 450)
                .background(AppColor.white1)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                Spacer().frame(width: 46)
            }
        }
    }
}


#Preview {
    ProductsEditView(viewModel: HomeViewModel())
}
