//
//  HistoryViewModel.swift
//  5GERS
//
//  Created by 이정동 on 8/4/24.
//

import Foundation

@Observable
final class HistoryViewModel {
    var outings: [Outing] = []
    var isDisplaySetAlert: Bool = false
    var selectedOutingIndex: Int = 0
    
    private let swiftDataManager = SwiftDataManager.shared
    
    init() {
        outings = self.fetchOutings()
    }
    
    private func fetchOutings() -> [Outing] {
        let result = swiftDataManager.fetch()
        switch result {
        case .success(let datas):
            return datas
                .map { Outing(time: $0.time.timeFormat, products: $0.products) }
                .sorted { $0.time < $1.time }
        case .failure(let error):
            print(error.localizedDescription)
            return []
        }
    }
}
