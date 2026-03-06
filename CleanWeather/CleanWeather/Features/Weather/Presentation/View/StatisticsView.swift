//
//  ConditionView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 26. 2. 2024..
//

import Foundation
import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: WeatherViewModel

    private var theme: WeatherSceneTheme {
        WeatherSceneTheme(
            condition: viewModel.weatherData.currentWeather?.conditionCode ?? "",
            daylight: viewModel.weatherData.currentWeather?.daylight ?? true
        )
    }

    private var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 14),
            GridItem(.flexible(), spacing: 14)
        ]
    }

    private var metrics: [WeatherMetricCardModel] {
        let current = viewModel.weatherData.currentWeather

        return [
            WeatherMetricCardModel(
                title: "Humidity",
                value: "\(Int(((current?.humidity ?? 0) * 100).rounded()))%",
                detail: "Comfort level",
                icon: "humidity.fill",
                progress: (current?.humidity ?? 0),
                tint: theme.accent
            ),
            WeatherMetricCardModel(
                title: "Visibility",
                value: String(format: "%.1f km", (current?.visibility ?? 0) / 1000),
                detail: "Current range",
                icon: "eye.fill",
                progress: min(1, (current?.visibility ?? 0) / 10000),
                tint: theme.secondaryAccent
            ),
            WeatherMetricCardModel(
                title: "Pressure",
                value: "\(Int((current?.pressure ?? 0).rounded())) mb",
                detail: "Sea level",
                icon: "gauge.with.dots.needle.33percent",
                progress: normalized((current?.pressure ?? 0), min: 980, max: 1040),
                tint: theme.windowGlow
            ),
            WeatherMetricCardModel(
                title: "Wind",
                value: "\(Int((current?.windSpeed ?? 0).rounded())) km/h",
                detail: "Surface speed",
                icon: "wind",
                progress: normalized((current?.windSpeed ?? 0), min: 0, max: 80),
                tint: theme.glow
            ),
            WeatherMetricCardModel(
                title: "UV Index",
                value: "\(current?.uvIndex ?? 0)",
                detail: "Exposure level",
                icon: "sun.max.fill",
                progress: normalized(Double(current?.uvIndex ?? 0), min: 0, max: 11),
                tint: theme.accent
            ),
            WeatherMetricCardModel(
                title: "Cloud Cover",
                value: "\(Int(((current?.cloudCover ?? 0) * 100).rounded()))%",
                detail: "Sky density",
                icon: "cloud.fill",
                progress: current?.cloudCover ?? 0,
                tint: theme.secondaryAccent
            )
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Atmospheric Detail")
                        .font(.system(size: 26, weight: .black, design: .rounded))
                        .foregroundStyle(.white)

                    Text("A compact metrics grid with live pressure, UV, wind, and sky data.")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.68))
                }

                Spacer()

                Image(systemName: "square.grid.2x2.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(theme.glow)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.black.opacity(0.14))
                    )
            }

            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(metrics) { metric in
                    WeatherMetricCard(metric: metric)
                }
            }
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

    private func normalized(_ value: Double, min lowerBound: Double, max upperBound: Double) -> Double {
        guard upperBound > lowerBound else {
            return 0
        }

        let progress = (value - lowerBound) / (upperBound - lowerBound)
        return min(1, max(0, progress))
    }
}

private struct WeatherMetricCardModel: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let detail: String
    let icon: String
    let progress: Double
    let tint: Color
}

private struct WeatherMetricCard: View {
    let metric: WeatherMetricCardModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(metric.tint.opacity(0.14))

                    Image(systemName: metric.icon)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(metric.tint)
                }
                .frame(width: 42, height: 42)

                Spacer()

                Text(metric.detail)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.5))
                    .multilineTextAlignment(.trailing)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(metric.title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.66))

                Text(metric.value)
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.08))
                    .frame(height: 10)

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [metric.tint, metric.tint.opacity(0.55)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(16, 140 * metric.progress), height: 10)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 170, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.black.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
}
