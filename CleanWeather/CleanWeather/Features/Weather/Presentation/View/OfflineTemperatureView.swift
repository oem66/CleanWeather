//
//  OfflineTemperatureView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 15. 6. 2024..
//

import Foundation
import SwiftUI

struct OfflineTemperatureView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Spacer()
            HStack {
                VStack {
                    HStack {
                        Text(viewModel.offlineCityName + ", ")
                            .font(.custom("Avenir-Medium", size: 25))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    
                    HStack {
                        Text(viewModel.offlineCountryName)
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
                
                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom, 30)
            .padding(.horizontal, 15)
            
            Image(systemName: viewModel.weatherSymbol)
                .resizable()
                .frame(width: 150, height: 120)
                .foregroundColor(.white)
            
            Text("\(viewModel.offlineWeatherData.currentWeather?.temperature.nextUp ?? 0.0, specifier: "%.0f")°C")
                .font(.custom("Avenir-Medium", size: 40))
                .fontWeight(.heavy)
                .foregroundColor(.white)
            Text(viewModel.offlineWeatherData.currentWeather?.conditionCode ?? "No Conditions data")
                .font(.custom("Avenir-Medium", size: 20))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                .cornerRadius(20)
//            Text("H:\(viewModel.offline.forecastDaily?.days[0].temperatureMax ?? 0.0, specifier: "%.0f")°C - L:\(viewModel.weatherData.forecastDaily?.days[0].temperatureMin ?? 0.0, specifier: "%.0f")°C")
//                .font(.custom("Avenir-Medium", size: 20))
//                .fontWeight(.bold)
//                .foregroundColor(.white)
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .background(Constants.defaultBackground)
    }
}
