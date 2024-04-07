//
//  HourlyForecastView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 26. 2. 2024..
//

import Foundation
import SwiftUI

struct DailyForecastView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("This Week")
                .font(.custom("Avenir-Medium", size: 25))
                .fontWeight(.heavy)
                .foregroundColor(.black)
                .padding(.bottom, 15)
                .padding(.leading, 15)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.weatherData.forecastDaily?.days ?? [DayWeatherConditions](), id: \.self) { day in
                        VStack(alignment: .center, spacing: 10) {
                            if let date = day.forecastStart {
                                Text("\(date.formatted(.dateTime.weekday()))")
                                    .font(.custom("Avenir-Medium", size: 28))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            Image("sun")
                                .resizable()
                                .frame(width: 60, height: 50)
                            Text("Max: \(day.temperatureMax, specifier: "%.0f")°C")
                                .font(.custom("Avenir-Medium", size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Min: \(day.temperatureMin, specifier: "%.0f")°C")
                                .font(.custom("Avenir-Medium", size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(10)
                        .background(Color(red: 45/255, green: 52/255, blue: 54/255))
                        .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 15)
            }
        }
        .padding(.top, 20)
    }
}
