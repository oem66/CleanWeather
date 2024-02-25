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
        VStack {
            // MARK: place ads here
            
            ScrollView(.vertical) {
                TemperatureView(viewModel: viewModel)
                HourlyForecastView(viewModel: viewModel)
            }
        }
        .onAppear {
            Task {
                //                await viewModel.getUserLocation()
                //                await viewModel.getWeather(location: viewModel.location)
            }
        }
    }
}

struct TemperatureView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Text("🇺🇸 Denver, CO")
                .font(.custom("Avenir-Medium", size: 30))
                .fontWeight(.heavy)
                .foregroundColor(.black)
                .padding(.top, 40)
            Image("cloudy")
                .resizable()
                .frame(width: 220, height: 190)
            Text("15°C")
                .font(.custom("Avenir-Medium", size: 40))
                .fontWeight(.heavy)
                .foregroundColor(.black)
            Text("Partly Cloudy")
                .font(.custom("Avenir-Medium", size: 20))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                .cornerRadius(20)
            Text("H:21° L:15°")
                .font(.custom("Avenir-Medium", size: 20))
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
    }
}

struct HourlyForecastView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @State private var hours = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(hours, id: \.self) { hour in
                    VStack(alignment: .center, spacing: 5) {
                        Image("sun")
                            .resizable()
                            .frame(width: 60, height: 50)
                        Text("15°")
                            .font(.custom("Avenir-Medium", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("\(hour) h")
                            .font(.custom("Avenir-Medium", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    .padding(10)
                    .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                    .cornerRadius(15)
                }
            }
            .padding(.horizontal, 15)
        }
    }
}
