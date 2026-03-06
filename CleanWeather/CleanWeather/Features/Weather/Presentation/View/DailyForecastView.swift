//
//  HourlyForecastView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 26. 2. 2024..
//

import Foundation
import SwiftUI

struct DailyForecastView: View {
    @ObservedObject var viewModel: WeatherViewModel

    private var theme: WeatherSceneTheme {
        WeatherSceneTheme(
            condition: viewModel.weatherData.currentWeather?.conditionCode ?? "",
            daylight: viewModel.weatherData.currentWeather?.daylight ?? true
        )
    }

    private var days: [DayWeatherConditions] {
        Array((viewModel.weatherData.forecastDaily?.days ?? []).prefix(7))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Seven Day Outlook")
                        .font(.system(size: 26, weight: .black, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Scrollable forecast cards with condition, precipitation, and daily range.")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.68))
                }

                Spacer()

                Image(systemName: "calendar")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(theme.secondaryAccent)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.black.opacity(0.14))
                    )
            }

            if days.isEmpty {
                Text("Daily forecast is still loading.")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color.black.opacity(0.12))
                    )
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(days, id: \.self) { day in
                            DailyForecastCard(day: day)
                        }
                    }
                    .padding(.horizontal, 1)
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
}

private struct DailyForecastCard: View {
    let day: DayWeatherConditions

    private var dayTheme: WeatherSceneTheme {
        WeatherSceneTheme(condition: day.conditionCode, daylight: true)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(dayLabel)
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text(dateLabel)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.64))
            }

            HStack(alignment: .center, spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(dayTheme.glow.opacity(0.14))

                    Image(systemName: dayTheme.symbolName)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(dayTheme.glow)
                }
                .frame(width: 62, height: 62)

                VStack(alignment: .leading, spacing: 6) {
                    Text(day.conditionCode)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(2)

                    Text("UV \(day.maxUvIndex)  •  \(Int((day.precipitationChance * 100).rounded()))% precipitation")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.62))
                        .lineLimit(2)
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("High")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.60))
                    Spacer()
                    Text("\(Int(day.temperatureMax.rounded()))°")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                }

                HStack {
                    Text("Low")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.60))
                    Spacer()
                    Text("\(Int(day.temperatureMin.rounded()))°")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.82))
                }

                GeometryReader { proxy in
                    let totalRange = max(1, day.temperatureMax - day.temperatureMin)
                    let progress = max(0.08, min(1, totalRange / 25))

                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.08))
                            .frame(height: 10)

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [dayTheme.accent, dayTheme.secondaryAccent],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: proxy.size.width * progress, height: 10)
                    }
                }
                .frame(height: 10)
            }

            Spacer(minLength: 0)

            HStack {
                Text("Moon")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.58))

                Spacer()

                Text(day.moonPhase.value.capitalized)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(dayTheme.windowGlow)
            }
        }
        .padding(18)
        .frame(width: 220, height: 250)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            dayTheme.buildingFront.opacity(0.86),
                            dayTheme.buildingSide.opacity(0.92)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.14), radius: 18, x: 0, y: 12)
    }

    private var dayLabel: String {
        guard let date = day.forecastStart else {
            return "Day"
        }

        return date.formatted(.dateTime.weekday(.wide))
    }

    private var dateLabel: String {
        guard let date = day.forecastStart else {
            return "--"
        }

        return date.formatted(.dateTime.day().month(.abbreviated))
    }
}
