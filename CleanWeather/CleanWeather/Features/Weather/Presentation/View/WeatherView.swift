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
        VStack(alignment: .leading) {
            // MARK: place ads here
            ScrollView(.vertical, showsIndicators: false) {
                TemperatureView(viewModel: viewModel)
                DailyForecastView(viewModel: viewModel)
                StatisticsView(viewModel: viewModel)
                HStack {
                    AirQualityView()
                    Spacer()
                }
                .padding(20)
            }
        }
        .onAppear {
            log.info("==================== Weather View ====================")
            Task {
                await viewModel.getUserLocation()
                await viewModel.getWeather(location: viewModel.location)
            }
        }
    }
}
