//
//  WhisperCaptionProApp.swift
//  WhisperCaptionPro
//
//  Created by 조형구 on 2/22/25.
//

import SwiftData
import SwiftUI

@main
struct WhisperCaptionProApp: App {
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
            ContentView()
                .frame(minWidth: 1000, minHeight: 700)
        }
        .modelContainer(sharedModelContainer)
    }
}
