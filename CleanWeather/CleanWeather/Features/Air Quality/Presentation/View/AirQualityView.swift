//
//  AirQualityView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 7. 3. 2024..
//

import Foundation
import SwiftUI

struct AirQualityView: View {
    @StateObject private var viewModel = AirQualityViewModel()
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                AQILineView()
                    .padding(.bottom, 5)
                    .padding(.top, 15)
                if let aqi = viewModel.airQualityData.list?[0].main?.aqi {
                    Text("\(aqi) AQI")
                        .fontWeight(.heavy)
                        .font(.custom("Avenir-Medium", size: 22))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 25)
                }
            }
        }
        .frame(width: 200)
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
        .cornerRadius(15)
        .onAppear {
            Task {
                await viewModel.getAirQuality()
            }
        }
    }
}

struct AQILineView: View {
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            
            VStack {
                
            }
            .frame(width: 30, height: 10)
            .background(Constants.aqiGood)
            
            VStack {
                
            }
            .frame(width: 30, height: 10)
            .background(Constants.aqiModerate)
            
            VStack {
                
            }
            .frame(width: 30, height: 10)
            .background(Constants.aqiUnhealthySensitiveGroups)
            
            VStack {
                
            }
            .frame(width: 30, height: 10)
            .background(Constants.aqiUnhealthy)
            
            VStack {
                
            }
            .frame(width: 30, height: 10)
            .background(Constants.aqiVeryUnhealthy)
            
            VStack {
                
            }
            .frame(width: 30, height: 10)
            .background(Constants.aqiHazardous)
            
            Spacer()
        }
        .frame(width: 180, height: 10)
        .cornerRadius(10)
    }
}
