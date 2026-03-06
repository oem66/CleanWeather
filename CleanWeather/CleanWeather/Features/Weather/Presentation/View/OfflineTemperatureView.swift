//
//  OfflineTemperatureView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 15. 6. 2024..
//

import Foundation
import SwiftUI

struct OfflineTemperatureView: View {
    @ObservedObject var viewModel: WeatherViewModel

    private var theme: WeatherSceneTheme {
        WeatherSceneTheme(
            condition: viewModel.offlineWeatherData.currentWeather?.conditionCode ?? "",
            daylight: viewModel.offlineWeatherData.currentWeather?.daylight ?? true
        )
    }

    private var temperatureText: String {
        guard let temperature = viewModel.offlineWeatherData.currentWeather?.temperature else {
            return "--°"
        }

        return "\(Int(temperature.rounded()))°"
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [theme.skyTop, theme.skyBottom, theme.horizon],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(theme.glow.opacity(0.22))
                .frame(width: 320, height: 320)
                .blur(radius: 50)
                .offset(x: -100, y: -260)

            VStack(spacing: 22) {
                Spacer()

                VStack(alignment: .leading, spacing: 18) {
                    Text(viewModel.offlineCityName.isEmpty ? "Offline mode" : viewModel.offlineCityName)
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundStyle(.white)

                    Text(viewModel.offlineCountryName.isEmpty ? "Last saved forecast" : viewModel.offlineCountryName)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.7))

                    HStack(alignment: .center, spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 26, style: .continuous)
                                .fill(Color.white.opacity(0.12))

                            Image(systemName: theme.symbolName)
                                .font(.system(size: 62, weight: .bold))
                                .foregroundStyle(theme.glow)
                        }
                        .frame(width: 132, height: 132)

                        VStack(alignment: .leading, spacing: 10) {
                            Text(temperatureText)
                                .font(.system(size: 64, weight: .black, design: .rounded))
                                .foregroundStyle(.white)

                            Text(viewModel.offlineWeatherData.currentWeather?.conditionCode ?? "Stored weather snapshot")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color.white.opacity(0.74))
                                .lineLimit(2)

                            Text(viewModel.currentDate.isEmpty ? Date.now.formatted(date: .abbreviated, time: .omitted) : viewModel.currentDate)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.white.opacity(0.58))
                        }
                    }

                    Text("Network unavailable. Showing the last saved location and forecast snapshot.")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.68))
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 34, style: .continuous)
                        .fill(Color.white.opacity(0.10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 34, style: .continuous)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 18)

                Spacer()
            }
        }
    }
}
