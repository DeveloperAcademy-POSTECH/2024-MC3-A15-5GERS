//
//  HomeView.swift
//  5GERS
//
//  Created by 이정동 on 7/30/24.
//

import SwiftUI


struct HomeView: View {
    @AppStorage(UserDefaultsKey.isTodayAfter) private var isAfterToday: Bool = false
    @State private var outing: Outing = .init(time: .now, products: [])
    
    init() {
        let uiColor = UIColor(AppColor.black)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
    }
    
    var body: some View {
        VStack {
            if isAfterToday { TimerView(outing: $outing) }
            else { SettingView(outing: outing) }
        }
        .onAppear {
            self.InitData()
        }
    }
}

// MARK: - Function
extension HomeView {
    private func InitData() {
        if isAfterToday {
            self.outing = UserDefaultsManager.shared.getOutingData()
        } else {
            self.outing = .init(time: .now, products: [])
        }
    }
}

#Preview {
    HomeView()
}
