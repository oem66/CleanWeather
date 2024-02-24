//
//  CleanWeatherApp.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import SwiftUI

@main
struct CleanWeatherApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
