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
            if let aqi = viewModel.airQualityData.list?[0].main?.aqi {
                Text("Air Quality: \(aqi)")
                    .fontWeight(.heavy)
            }
        }
        .onAppear {
            Task {
                await viewModel.getAirQuality()
            }
        }
    }
}
