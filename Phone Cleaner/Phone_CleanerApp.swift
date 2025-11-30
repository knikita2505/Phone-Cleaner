//
//  Phone_CleanerApp.swift
//  Phone Cleaner
//
//  Created by Nikita on 30.11.2025.
//

import SwiftUI

@main
struct Phone_CleanerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
