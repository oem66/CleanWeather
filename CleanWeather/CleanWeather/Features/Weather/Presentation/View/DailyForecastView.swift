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
                    LazyHStack(spacing: 16) {
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

    private var precipitationText: String {
        "\(Int((day.precipitationChance * 100).rounded()))%"
    }

    private var rangeFraction: CGFloat {
        let totalRange = max(1, day.temperatureMax - day.temperatureMin)
        return max(0.18, min(1, totalRange / 18))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(dayLabel)
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)

                    Text(dateLabel)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.62))
                }

                Spacer(minLength: 8)

                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(dayTheme.glow.opacity(0.14))

                    Image(systemName: dayTheme.symbolName)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(dayTheme.glow)
                }
                .frame(width: 54, height: 54)
            }

            Text(day.conditionCode)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(2)
                .frame(height: 36, alignment: .topLeading)

            HStack(spacing: 8) {
                ForecastInfoBadge(title: "UV", value: "\(day.maxUvIndex)", tint: dayTheme.accent)
                ForecastInfoBadge(title: "Rain", value: precipitationText, tint: dayTheme.secondaryAccent)
                ForecastInfoBadge(title: "Moon", value: moonLabel, tint: dayTheme.windowGlow)
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("High")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.56))

                        Text("\(Int(day.temperatureMax.rounded()))°")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Low")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.56))

                        Text("\(Int(day.temperatureMin.rounded()))°")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.84))
                    }
                }

                GeometryReader { proxy in
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
                            .frame(width: proxy.size.width * rangeFraction, height: 10)
                    }
                }
                .frame(height: 10)
            }

            Spacer(minLength: 0)

            HStack {
                Text("Sun")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.54))

                Spacer()

                Text(sunWindowLabel)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.78))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .padding(18)
        .frame(width: 238, height: 232, alignment: .topLeading)
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

    private var moonLabel: String {
        day.moonPhase.value
            .replacingOccurrences(of: "Moon", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }

    private var sunWindowLabel: String {
        "\(day.sunrise.formatted(.dateTime.hour().minute())) - \(day.sunset.formatted(.dateTime.hour().minute()))"
    }
}

private struct ForecastInfoBadge: View {
    let title: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.54))

            Text(value)
                .font(.system(size: 12, weight: .black, design: .rounded))
                .foregroundStyle(tint)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.black.opacity(0.12))
        )
    }
}
