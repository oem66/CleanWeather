//
//  ContentView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import SwiftUI
import CoreData

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
            Text("Weather View")
        }
        .onAppear {
            Task {
                await viewModel.getUserLocation()
                await viewModel.getWeather(location: viewModel.location)
            }
        }
    }
}
