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
                VStack(spacing: 10) {
                    TemperatureView(viewModel: viewModel)
                    TemperatureChartView(viewModel: viewModel)
                    DailyForecastView(viewModel: viewModel)
                    StatisticsView(viewModel: viewModel)
                    AirQualityView()
                        .padding(.bottom, 150)
                }
            }
        }
        .background(Constants.defaultBackground)
        .onAppear {
            log.info("==================== Weather View ====================")
            Task {
                await viewModel.getUserLocation()
            }
        }
    }
}
