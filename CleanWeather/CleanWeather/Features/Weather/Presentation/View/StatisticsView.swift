//
//  ConditionView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 26. 2. 2024..
//

import Foundation
import SwiftUI


struct StatisticsView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    let columns = [
        GridItem(.fixed(180)),
        GridItem(.fixed(180))
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Statistics")
                .font(.custom("Avenir-Medium", size: 25))
                .fontWeight(.heavy)
                .foregroundColor(.black)
                .padding(.bottom, 15)
                .padding(.leading, 15)
            Group {
                LazyVGrid(columns: columns, spacing: 20) {
                    StatisticCard("AQI", nil, 30)
                    StatisticCard("UV Index", nil, viewModel.weatherData.currentWeather?.uvIndex)
                }
                LazyVGrid(columns: columns, spacing: 20) {
                    StatisticCard("Pressure", viewModel.weatherData.currentWeather?.pressure, nil)
                    StatisticCard("Humidity", viewModel.weatherData.currentWeather?.humidity, nil)
                }
                LazyVGrid(columns: columns, spacing: 20) {
                    StatisticCard("Feels Like", viewModel.weatherData.currentWeather?.temperatureApparent, nil)
                    StatisticCard("Visibility", viewModel.weatherData.currentWeather?.visibility, nil)
                }
                LazyVGrid(columns: columns, spacing: 20) {
                    StatisticCard("Wind Speed", viewModel.weatherData.currentWeather?.windSpeed, nil)
                    StatisticCard("Wind Gust", viewModel.weatherData.currentWeather?.windGust, nil)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    private func StatisticCard(_ title: String, _ doubleValue: Double?, _ intValue: Int?) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.custom("Avenir-Medium", size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                Spacer()
            }
            if let doubleValue {
                Text("\(doubleValue, specifier: "%.1f")")
                    .font(.custom("Avenir-Medium", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            } else if let intValue {
                Text("\(intValue)")
                    .font(.custom("Avenir-Medium", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 10)
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
        .cornerRadius(15)
    }
}
