//
//  ContentView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import SwiftUI
import CoreData

struct WeatherView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some View {
        if networkMonitor.isConnected {
            VStack(alignment: .leading) {
                // MARK: place ads here
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 10) {
                        TemperatureView(viewModel: viewModel)
                        TemperatureChartView(viewModel: viewModel)
                        DailyForecastView(viewModel: viewModel)
                        StatisticsView(viewModel: viewModel)
    //                    AirQualityView()
    //                        .padding(.bottom, 150)
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
        } else {
            VStack(alignment: .center) {
                Spacer()
                Text("\(viewModel.offlineWeatherData.currentWeather?.pressure)")
                    .font(.custom("Avenir-Medium", size: 20))
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                Spacer()
            }
        }
    }
}
