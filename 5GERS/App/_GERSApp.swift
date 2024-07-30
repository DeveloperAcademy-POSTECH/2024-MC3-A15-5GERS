//
//  _GERSApp.swift
//  5GERS
//
//  Created by 이정동 on 7/29/24.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct _GERSApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    private let modelContainer: ModelContainer = {
        let schema = Schema([OutingSD.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            TestHomeView()
                .modelContainer(modelContainer)
        }
    }
}
