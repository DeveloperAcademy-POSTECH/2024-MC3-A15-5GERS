//
//  HomeView.swift
//  5GERS
//
//  Created by 이정동 on 7/30/24.
//

import SwiftUI

struct HomeView: View {
    @AppStorage(UserDefaultsKey.isTodayAfter) private var isAfterToday: Bool = false
    
    var body: some View {
        NavigationStack {
            if isAfterToday { TimerView() }
            else { SettingView() }
        }
    }
}

#Preview {
    HomeView()
        .environment(HomeViewModel())
}
