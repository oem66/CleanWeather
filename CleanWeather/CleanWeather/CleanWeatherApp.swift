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
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.writeMOC)
        }
    }
}

private struct MainTabView: View {
    @StateObject private var cityExplorerViewModel = CityExplorerViewModel()

    var body: some View {
        TabView {
            WeatherView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass.circle.fill")
                }

            ClimateMapView(viewModel: cityExplorerViewModel)
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }

            MultipleCitiesView(viewModel: cityExplorerViewModel)
                .tabItem {
                    Label("Cities", systemImage: "building.2.crop.circle.fill")
                }
        }
        .tint(.white)
    }
}
