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
            VStack {
                HStack {
                    Text(viewModel.placemark + ", ")
                        .font(.custom("Avenir-Medium", size: 25))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Text(viewModel.country)
                        .font(.custom("Avenir-Medium", size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(Constants.customGrayColor)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                    Spacer()
                }
                HStack {
                    Text(viewModel.currentDate)
                        .font(.custom("Avenir-Medium", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Constants.customGrayColor)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                    Spacer()
                }
            }
            .padding(.top, 20)
            
            Image("sun")
                .resizable()
                .frame(width: 220, height: 190)
            
            Text("\(viewModel.weatherData.currentWeather?.temperature.nextUp ?? 0.0, specifier: "%.0f")°C")
                .font(.custom("Avenir-Medium", size: 40))
                .fontWeight(.heavy)
                .foregroundColor(.white)
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
                .foregroundColor(.white)
        }
        .padding(.horizontal, 15)
        .onAppear {
            viewModel.formatDate()
        }
    }
}
