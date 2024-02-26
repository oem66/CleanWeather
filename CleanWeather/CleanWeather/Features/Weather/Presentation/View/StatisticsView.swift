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
            Group {
                LazyVGrid(columns: columns, spacing: 20) {
                    StatisticCard("AQI", nil, 30)
                    StatisticCard("UV Index", nil, 3)
                }
                LazyVGrid(columns: columns, spacing: 20) {
                    StatisticCard("Pressure", 1009.3, nil)
                    StatisticCard("Humidity", nil, 85)
                }
                LazyVGrid(columns: columns, spacing: 20) {
                    StatisticCard("Feels Like", 18.5, nil)
                    StatisticCard("Visibility", nil, 3860)
                }
                LazyVGrid(columns: columns, spacing: 20) {
                    StatisticCard("Wind Speed", 18.5, nil)
                    StatisticCard("Wind Gust", 35.8, nil)
                }
            }
            .padding(.horizontal, 20)
        }
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
