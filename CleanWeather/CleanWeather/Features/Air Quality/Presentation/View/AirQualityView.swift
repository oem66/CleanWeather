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
            Text("Air Quality")
                .fontWeight(.heavy)
        }
        .onAppear {
            Task {
                await viewModel.getUserLocation()
                await viewModel.getAirQuality()
            }
        }
    }
}
