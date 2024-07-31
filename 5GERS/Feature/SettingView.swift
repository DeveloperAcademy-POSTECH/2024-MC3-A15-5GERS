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
                        viewModel.isPresented = true
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
                
                if viewModel.isPresented {
                    ProductsInputView(viewModel: homeViewModel)
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

struct ProductsInputView: View {
    @Bindable private var viewModel: HomeViewModel
    @FocusState private var focusedField: Int?
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            AppColor.black.opacity(0.5).ignoresSafeArea()
            
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
                                focusedField = viewModel.products.isEmpty ? nil : 0
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
                        ForEach(Array($viewModel.products.enumerated()), id: \.element.id) { idx, product in
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
                .frame(height: 450)
                .background(AppColor.white1)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                Spacer().frame(width: 46)
            }
        }
    }
}

struct TextFieldItem: Identifiable {
    let id = UUID()
    var text: String
}

#Preview {
    SettingView()
        .environment(HomeViewModel())
}
