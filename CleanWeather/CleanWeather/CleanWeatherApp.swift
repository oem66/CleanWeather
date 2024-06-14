//
//  CleanWeatherApp.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import SwiftUI

@main
struct CleanWeatherApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WeatherView()
                    .environment(\.managedObjectContext, persistenceController.writeMOC)
            }
        }
    }
}
