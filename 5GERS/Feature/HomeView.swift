//
//  HomeView.swift
//  5GERS
//
//  Created by 이정동 on 7/30/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(HomeViewModel.self) private var homeViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.background.ignoresSafeArea()
                
                if homeViewModel.outing.time.isAfterToday {
                    TimerView()
                } else {
                    SettingView()
                }
                
                if homeViewModel.isPresentedProductsView {
                    ProductsEditView(viewModel: homeViewModel)
                }
            }
            
        }
    }
}

#Preview {
    HomeView()
        .environment(HomeViewModel())
}
