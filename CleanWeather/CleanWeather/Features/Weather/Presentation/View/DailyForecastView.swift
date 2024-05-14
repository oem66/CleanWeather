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
                .foregroundColor(.white)
                .padding(.bottom, 15)
                .padding(.leading, 20)
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(viewModel.weatherData.forecastDaily?.days ?? [DayWeatherConditions](), id: \.self) { day in
                        HStack {
                            if let date = day.forecastStart {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(date.formatted(.dateTime.weekday()))")
                                            .font(.custom("Avenir-Medium", size: 20))
                                            .fontWeight(.heavy)
                                            .foregroundColor(.white)
                                        Text(getFormattedDate(date: date))
                                            .font(.custom("Avenir-Medium", size: 20))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                }
                                .frame(width: 70)
                                .padding(.leading, 20)
                            }
                            Spacer()
                            Text("\(day.temperatureMax, specifier: "%.0f")°")
                                .font(.custom("Avenir-Medium", size: 20))
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                            Text(" \(day.temperatureMin, specifier: "%.0f")°")
                                .font(.custom("Avenir-Medium", size: 20))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: viewModel.setWeatherSymbolToDailyForecast(weatherCondition: day.conditionCode))
                                .resizable()
                                .frame(width: 40, height: 35)
                                .foregroundColor(.white)
                                .padding(.trailing, 20)
//                            Spacer()
//                            Text(day.conditionCode)
//                                .font(.custom("Avenir-Medium", size: 20))
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                            Spacer()
                        }
                        .padding(10)
                        .background(Constants.cardItemBackground)
                        .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 15)
            }
        }
        .padding(.top, 20)
    }
    
    private func getFormattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter.string(from: date)
    }
}
