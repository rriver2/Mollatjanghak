//
//  janghakhereApp.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/15/24.
//

import SwiftUI
import SwiftData

@main
struct janghakhereApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            FirstView()
        }
        .modelContainer(sharedModelContainer)
    }
}
