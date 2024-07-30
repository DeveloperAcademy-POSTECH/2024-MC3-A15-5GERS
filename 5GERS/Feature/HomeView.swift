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
        ZStack {
            if homeViewModel.outing.time.isAfterToday {
                TimerView()
            } else {
                SettingView()
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(HomeViewModel())
}
