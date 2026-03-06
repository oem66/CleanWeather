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
                VStack(spacing: 22) {
                    TemperatureView(viewModel: viewModel)
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

    var body: some View {
        GeometryReader { proxy in
            TimelineView(.animation(minimumInterval: 1.0 / 24.0, paused: false)) { timeline in
                let time = timeline.date.timeIntervalSinceReferenceDate

                ZStack {
                    LinearGradient(
                        colors: [theme.skyTop, theme.skyBottom, theme.horizon],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    Circle()
                        .fill(theme.glow.opacity(theme.isStormy ? 0.18 : 0.26))
                        .frame(width: proxy.size.width * 0.82)
                        .blur(radius: 80)
                        .offset(
                            x: proxy.size.width * (theme.isNight ? 0.28 : -0.18),
                            y: -proxy.size.height * 0.28
                        )

                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        theme.accent.opacity(0.14),
                                        theme.secondaryAccent.opacity(0.04)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(
                                width: proxy.size.width * (0.5 + (CGFloat(index) * 0.08)),
                                height: proxy.size.width * (0.5 + (CGFloat(index) * 0.08))
                            )
                            .blur(radius: 55)
                            .offset(
                                x: CGFloat(sin(time * 0.12 + Double(index))) * 44,
                                y: CGFloat(cos(time * 0.15 + Double(index))) * 28
                            )
                            .position(
                                x: proxy.size.width * (index == 1 ? 0.82 : 0.18),
                                y: proxy.size.height * (index == 2 ? 0.82 : 0.24)
                            )
                    }

                    VStack {
                        Spacer()

                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        theme.cityBase.opacity(0.12),
                                        Color.black.opacity(0.02)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: proxy.size.height * 0.28)
                            .blur(radius: 16)
                    }
                }
            }
        }
    }
}
