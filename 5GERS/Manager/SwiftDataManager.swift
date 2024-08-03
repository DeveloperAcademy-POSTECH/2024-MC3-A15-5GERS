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
    case deleteError
    case notFound
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
    
    private func findSwiftData(_ data: Outing) -> Result<OutingSD, SwiftDataError> {
        let time = data.time
        let predicate = #Predicate<OutingSD> { $0.time == time }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        do {
            let swiftDatas = try modelContext.fetch(descriptor)
            guard let swiftData = swiftDatas.first else { return .failure(.notFound) }
            return .success(swiftData)
        } catch {
            return .failure(.notFound)
        }
    }
    
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
    
    func update(_ data: Outing) {
        let result = findSwiftData(data)
        switch result {
        case .success(let model):
            model.products = data.products
            print("update")
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func delete(_ data: Outing) throws {
        let result = findSwiftData(data)
        switch result {
        case .success(let data):
            modelContext.delete(data)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
