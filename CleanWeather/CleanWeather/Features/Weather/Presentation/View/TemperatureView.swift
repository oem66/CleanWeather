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
