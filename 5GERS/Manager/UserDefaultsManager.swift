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
    
    private init() {}
    
    func setIsTodayAfter(_ bool: Bool) {
        userDefaults.setValue(bool, forKey: UserDefaultsKey.isTodayAfter)
    }
    
    func setOutingData(_ data: Outing) {
        if let encodedData = try? JSONEncoder().encode(data) {
            userDefaults.set(encodedData, forKey: UserDefaultsKey.outing)
        }
    }
    
    func getOutingData() -> Outing {
        if let data = userDefaults.data(forKey: UserDefaultsKey.outing) {
            if let decodedData = try? JSONDecoder().decode(Outing.self, from: data) {
                return decodedData
            }
        }
        
        return Outing(time: .now, products: [])
    }
    
    func removeOutingData() {
        userDefaults.set(nil, forKey: UserDefaultsKey.outing)
    }
}
