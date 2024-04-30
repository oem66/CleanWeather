//
//  TemperatureView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 26. 2. 2024..
//

import Foundation
import SwiftUI

struct TemperatureView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            HStack {
                Text(viewModel.placemark + ",")
                    .font(.custom("Avenir-Medium", size: 30))
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                Text(viewModel.country)
                    .font(.custom("Avenir-Medium", size: 30))
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
            }
            
            Image("sun")
                .resizable()
                .frame(width: 220, height: 190)
            
            Text("\(viewModel.weatherData.currentWeather?.temperature.nextUp ?? 0.0, specifier: "%.0f")°C")
                .font(.custom("Avenir-Medium", size: 40))
                .fontWeight(.heavy)
                .foregroundColor(.black)
            Text(viewModel.weatherData.currentWeather?.conditionCode ?? "No Conditions data")
                .font(.custom("Avenir-Medium", size: 20))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                .cornerRadius(20)
            Text("H:\(viewModel.weatherData.forecastDaily?.days[0].temperatureMax ?? 0.0, specifier: "%.0f")°C - L:\(viewModel.weatherData.forecastDaily?.days[0].temperatureMin ?? 0.0, specifier: "%.0f")°C")
                .font(.custom("Avenir-Medium", size: 20))
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
    }
}
