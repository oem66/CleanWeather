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
                if let aqi = viewModel.airQualityData.list?[0].main?.aqi {
                    Text("\(aqi) AQI")
                        .fontWeight(.heavy)
                        .font(.custom("Avenir-Medium", size: 22))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 25)
                }
            }
        }
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
        .cornerRadius(15)
        .onAppear {
            Task {
                await viewModel.getAirQuality()
            }
        }
    }
}
