//
//  ContentView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import SwiftUI
import CoreData

struct WeatherView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()

    private var theme: WeatherSceneTheme {
        WeatherSceneTheme(
            condition: viewModel.weatherData.currentWeather?.conditionCode ?? "",
            daylight: viewModel.weatherData.currentWeather?.daylight ?? true
        )
    }

    var body: some View {
        Group {
            if networkMonitor.isConnected {
                onlineView
            } else {
                OfflineTemperatureView(viewModel: viewModel)
                    .onAppear {
                        viewModel.getOfflineWeather()
                        viewModel.getOfflineLocation()
                        viewModel.formatDate()
                    }
            }
        }
    }

    private var onlineView: some View {
        ZStack {
            AnimatedWeatherBackdrop(theme: theme)
                .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 22) {
                    TemperatureView(viewModel: viewModel)
                    CityDiscoveryHub { preset in
                        viewModel.getWeatherForNewLocation(location: preset.location)
                    }
                    TemperatureChartView(viewModel: viewModel)
                    DailyForecastView(viewModel: viewModel)
                    StatisticsView(viewModel: viewModel)
                        .padding(.bottom, 30)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .refreshable {
                await viewModel.getUserLocation()
            }
        }
        .onAppear {
            log.info("==================== Weather View ====================")
            viewModel.formatDate()

            Task {
                await viewModel.getUserLocation()
            }
        }
    }
}

private struct AnimatedWeatherBackdrop: View {
    let theme: WeatherSceneTheme
    @State private var animateBackdrop = false

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    colors: [theme.skyTop, theme.skyBottom, theme.horizon],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Circle()
                    .fill(theme.glow.opacity(theme.isStormy ? 0.16 : 0.24))
                    .frame(width: proxy.size.width * 0.76)
                    .blur(radius: 72)
                    .offset(
                        x: proxy.size.width * (theme.isNight ? 0.24 : -0.14),
                        y: -proxy.size.height * 0.24
                    )

                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    theme.accent.opacity(0.12),
                                    theme.secondaryAccent.opacity(0.03)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(
                            width: proxy.size.width * (0.46 + (CGFloat(index) * 0.07)),
                            height: proxy.size.width * (0.46 + (CGFloat(index) * 0.07))
                        )
                        .blur(radius: 50)
                        .offset(
                            x: animateBackdrop ? CGFloat(index - 1) * 26 : CGFloat(index - 1) * -18,
                            y: animateBackdrop ? CGFloat(index) * 12 : CGFloat(index) * -8
                        )
                        .position(
                            x: proxy.size.width * (index == 1 ? 0.82 : 0.18),
                            y: proxy.size.height * (index == 2 ? 0.82 : 0.24)
                        )
                        .animation(
                            .easeInOut(duration: 10 + Double(index * 2))
                                .repeatForever(autoreverses: true),
                            value: animateBackdrop
                        )
                }

                VStack {
                    Spacer()

                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    theme.cityBase.opacity(0.10),
                                    Color.black.opacity(0.02)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: proxy.size.height * 0.28)
                        .blur(radius: 14)
                }
            }
            .onAppear {
                animateBackdrop = true
            }
        }
    }
}

private struct CityDiscoveryHub: View {
    let onSelect: (CityPreset) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 6) {
                Text("City Search Deck")
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text("Jump between large urban systems and smaller local climates without leaving the weather tab.")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.68))
            }

            CityDiscoveryRail(title: "Large Cities", cities: CityPreset.majorCities, onSelect: onSelect)
            CityDiscoveryRail(title: "Smaller Cities", cities: CityPreset.smallerCities, onSelect: onSelect)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.12), Color.white.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.18), radius: 20, x: 0, y: 16)
    }
}

private struct CityDiscoveryRail: View {
    let title: String
    let cities: [CityPreset]
    let onSelect: (CityPreset) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundStyle(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(cities) { city in
                        Button {
                            onSelect(city)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(city.name)
                                    .font(.system(size: 16, weight: .black, design: .rounded))
                                    .foregroundStyle(.white)
                                    .lineLimit(1)

                                Text(city.country)
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.white.opacity(0.62))
                                    .lineLimit(2)
                            }
                            .padding(14)
                            .frame(width: 150, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .fill(Color.black.opacity(0.12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 1)
            }
        }
    }
}
