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
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                AQILineView(width: geometry.size.width - 20, height: 15)
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
            .frame(width: geometry.size.width - 20)
            .background(Color(red: 0.96, green: 0.96, blue: 0.96))
            .cornerRadius(15)
            .padding([.horizontal], 20)
            .onAppear {
                Task {
                    await viewModel.getAirQuality()
                }
            }
        }
    }
}

struct AQILineView: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            VStack {
                
            }
            .frame(width: width/7, height: 15)
            .background(Constants.aqiGood)
            
            VStack {
                
            }
            .frame(width: width/7, height: 15)
            .background(Constants.aqiModerate)
            
            VStack {
                
            }
            .frame(width: width/7, height: 15)
            .background(Constants.aqiUnhealthySensitiveGroups)
            
            VStack {
                
            }
            .frame(width: width/7, height: 15)
            .background(Constants.aqiUnhealthy)
            
            VStack {
                
            }
            .frame(width: width/7, height: 15)
            .background(Constants.aqiVeryUnhealthy)
            
            VStack {
                
            }
            .frame(width: width/7, height: 15)
            .background(Constants.aqiHazardous)
            Spacer()
        }
    }
}
