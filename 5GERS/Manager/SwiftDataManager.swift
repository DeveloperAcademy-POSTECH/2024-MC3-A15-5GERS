//
//  SwiftDataManager.swift
//  5GERS
//
//  Created by 이정동 on 7/30/24.
//

import Foundation
import SwiftData

enum SwiftDataError: Error {
    case fetchError
}

final class SwiftDataManager {
    static let shared = SwiftDataManager()
    private init() {}
    
    private let modelContext: ModelContext = {
        let schema = Schema([OutingSD.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])
            return ModelContext(container)
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
    
    func create(_ data: Outing) {
        let swiftData = OutingSD(time: data.time, products: data.products)
        self.modelContext.insert(swiftData)
    }
    
    func fetch() -> Result<[Outing], SwiftDataError> {
        // TODO: hour, minute만 비교해서 정렬 필요
        let sort = SortDescriptor(\OutingSD.time, order: .forward)
        let descriptor = FetchDescriptor(sortBy: [sort])
        
        do {
            let datas = try modelContext.fetch(descriptor)
            return .success(datas.map { $0.toEntity() })
        } catch {
            return .failure(.fetchError)
        }
        
    }
}
