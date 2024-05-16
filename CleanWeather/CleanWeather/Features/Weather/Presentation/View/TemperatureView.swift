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
    @State private var isAnimating = false
    @State private var showSheetView = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            HStack {
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
                
                Spacer()
                
                VStack {
                    Button {
                        //                            viewModel.showLocationSelectionView.toggle()
                        showSheetView.toggle()
                    } label: {
                        Image(systemName: "square.grid.2x2.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Constants.customGrayColor)
                            .padding(15)
                    }
                }
                .background(Constants.cardItemBackground)
                .cornerRadius(10)
            }
            .padding(.top, 20)
            .padding(.bottom, 30)
            
            Image(systemName: viewModel.weatherSymbol)
                .resizable()
                .frame(width: 150, height: 120)
                .foregroundColor(.white)
            
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
        .fullScreenCover(isPresented: $showSheetView) {
            SelectLocationView(viewModel: viewModel,
                                 showSheetView: $showSheetView)
        }
    }
}
