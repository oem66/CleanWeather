//
//  SelectLocationView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 14. 5. 2024..
//

import Foundation
import SwiftUI
import MapKit

struct SelectLocationView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @Binding var showSheetView: Bool

    private var theme: WeatherSceneTheme {
        WeatherSceneTheme(
            condition: viewModel.weatherData.currentWeather?.conditionCode ?? "",
            daylight: viewModel.weatherData.currentWeather?.daylight ?? true
        )
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
                .frame(width: 280, height: 280)
                .blur(radius: 40)
                .offset(x: -120, y: -280)

            VStack(spacing: 18) {
                HStack {
                    Text("Search City")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundStyle(.white)

                    Spacer()

                    Button {
                        showSheetView.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.12))
                            )
                    }
                    .buttonStyle(.plain)
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text("Type a city name and preview the coordinates before switching the animated forecast scene.")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.72))

                    CustomTextField(viewModel: viewModel)

                    if let coordinates = viewModel.coordinates {
                        VStack(alignment: .leading, spacing: 10) {
                            Label(viewModel.locationName.isEmpty ? "Location ready" : viewModel.locationName, systemImage: "mappin.and.ellipse")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)

                            Text(String(format: "Lat %.4f  •  Lon %.4f", coordinates.latitude, coordinates.longitude))
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.white.opacity(0.66))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(Color.black.opacity(0.16))
                        )
                    }

                    Button {
                        showSheetView.toggle()

                        if let latitude = viewModel.coordinates?.latitude,
                           let longitude = viewModel.coordinates?.longitude {
                            viewModel.getWeatherForNewLocation(
                                location: CLLocation(latitude: latitude, longitude: longitude)
                            )
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Load Weather Scene")
                                .font(.system(size: 18, weight: .black, design: .rounded))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [theme.accent, theme.secondaryAccent],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.coordinates == nil)
                    .opacity(viewModel.coordinates == nil ? 0.5 : 1)
                }
                .padding(22)
                .background(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.white.opacity(0.10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                )
            }
            .padding(.horizontal, 18)
        }
        .presentationBackground(.clear)
    }
}
