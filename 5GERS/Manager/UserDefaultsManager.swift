//
//  UserDefaultsManager.swift
//  5GERS
//
//  Created by 이정동 on 7/30/24.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let userDefaults = UserDefaults.standard
    
    let outingKey = "outing"
    
    private init() {}
    
    func setOutingData(_ data: Outing) {
        if let encodedData = try? JSONEncoder().encode(data) {
            userDefaults.set(encodedData, forKey: outingKey)
        }
    }
    
    func getOutingData() -> Outing {
        if let data = userDefaults.data(forKey: outingKey) {
            if let decodedData = try? JSONDecoder().decode(Outing.self, from: data) {
                return decodedData
            }
        }
        
        return Outing(time: .now.addingTimeInterval(-1), products: [])
    }
    
    func removeOutingData() {
        userDefaults.removeObject(forKey: outingKey)
    }
}
