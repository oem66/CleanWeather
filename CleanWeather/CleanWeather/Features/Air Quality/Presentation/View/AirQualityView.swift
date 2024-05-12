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
                    .padding(.top, 15)
                if let aqi = viewModel.airQualityData.list?[0].main?.aqi {
                    Text("\(aqi) AQI")
                        .fontWeight(.heavy)
                        .font(.custom("Avenir-Medium", size: 22))
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                }
            }
            .frame(width: geometry.size.width - 20)
            .background(Constants.cardItemBackground)
            .cornerRadius(15)
            .padding([.horizontal], 20)
            .onAppear {
                viewModel.getUserLocation()
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
            .clipShape(.rect(topLeadingRadius: 8))
            .clipShape(.rect(bottomLeadingRadius: 8))
            
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
            .clipShape(.rect(topTrailingRadius: 8))
            .clipShape(.rect(bottomTrailingRadius: 8))
            Spacer()
        }
    }
}
