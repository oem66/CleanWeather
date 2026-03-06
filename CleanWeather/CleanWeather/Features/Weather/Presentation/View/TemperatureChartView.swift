//
//  TemperatureChartView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 8. 4. 2024..
//

import Foundation
import SwiftUI
import Charts

private struct HourlyTemperaturePoint: Identifiable, Equatable {
    let date: Date
    let temperature: Double
    let apparentTemperature: Double
    let conditionCode: String
    let precipitationChance: Double

    var id: Date { date }
}

struct TemperatureChartView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @State private var selectedPoint: HourlyTemperaturePoint?

    private var theme: WeatherSceneTheme {
        WeatherSceneTheme(
            condition: viewModel.weatherData.currentWeather?.conditionCode ?? "",
            daylight: viewModel.weatherData.currentWeather?.daylight ?? true
        )
    }

    private var points: [HourlyTemperaturePoint] {
        Array((viewModel.weatherData.forecastHourly?.hours ?? []).prefix(12).map {
            HourlyTemperaturePoint(
                date: $0.forecastStart,
                temperature: $0.temperature,
                apparentTemperature: $0.temperatureApparent,
                conditionCode: $0.conditionCode,
                precipitationChance: $0.precipitationChance,
            )
        })
    }

    private var activePoint: HourlyTemperaturePoint? {
        if let selectedPoint, points.contains(selectedPoint) {
            return selectedPoint
        }

        return points.first
    }

    private var minTemperature: Double {
        (points.map(\.temperature).min() ?? 0) - 4
    }

    private var maxTemperature: Double {
        (points.map(\.temperature).max() ?? 0) + 4
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Hourly Flow")
                        .font(.system(size: 26, weight: .black, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Drag across the curve to inspect the next 12 hours.")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.68))
                }

                Spacer()

                Image(systemName: "timeline.selection")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(theme.accent)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.black.opacity(0.14))
                    )
            }

            if points.isEmpty {
                placeholder
            } else {
                detailStrip
                chart
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
        .onAppear {
            if selectedPoint == nil {
                selectedPoint = points.first
            }
        }
        .onChange(of: points) { newValue in
            if let current = selectedPoint, newValue.contains(current) {
                return
            }

            selectedPoint = newValue.first
        }
    }

    private var placeholder: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Waiting for hourly forecast")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("WeatherKit data will populate the interactive chart as soon as the current location finishes syncing.")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.black.opacity(0.12))
        )
    }

    private var detailStrip: some View {
        let point = activePoint ?? points[0]
        let pointTheme = WeatherSceneTheme(condition: point.conditionCode, daylight: true)

        return HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(point.date.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated))))
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text(point.conditionCode)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.72))
                    .lineLimit(1)
            }

            Spacer()

            ForecastMetricChip(
                icon: pointTheme.symbolName,
                title: "Temp",
                value: "\(Int(point.temperature.rounded()))°",
                tint: theme.accent
            )

            ForecastMetricChip(
                icon: "thermometer.medium",
                title: "Feels",
                value: "\(Int(point.apparentTemperature.rounded()))°",
                tint: theme.secondaryAccent
            )

            ForecastMetricChip(
                icon: "drop.fill",
                title: "Rain",
                value: "\(Int((point.precipitationChance * 100).rounded()))%",
                tint: theme.windowGlow
            )
        }
    }

    private var chart: some View {
        Chart {
            ForEach(points) { point in
                AreaMark(
                    x: .value("Time", point.date),
                    yStart: .value("Base", minTemperature),
                    yEnd: .value("Temperature", point.temperature)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            theme.accent.opacity(0.30),
                            theme.accent.opacity(0.02)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                LineMark(
                    x: .value("Time", point.date),
                    y: .value("Temperature", point.temperature)
                )
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .foregroundStyle(
                    LinearGradient(
                        colors: [theme.accent, theme.secondaryAccent],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            }

            if let activePoint {
                RuleMark(x: .value("Selected Hour", activePoint.date))
                    .foregroundStyle(Color.white.opacity(0.35))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))

                PointMark(
                    x: .value("Selected Time", activePoint.date),
                    y: .value("Selected Temperature", activePoint.temperature)
                )
                .foregroundStyle(.white)
                .symbolSize(100)
                .annotation(position: .top) {
                    Text("\(Int(activePoint.temperature.rounded()))°")
                        .font(.system(size: 12, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.28))
                        )
                }
            }
        }
        .frame(height: 230)
        .chartYScale(domain: minTemperature...maxTemperature)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 4)) { value in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.8, dash: [3, 5]))
                    .foregroundStyle(Color.white.opacity(0.08))
                AxisTick(stroke: StrokeStyle(lineWidth: 0.8))
                    .foregroundStyle(Color.white.opacity(0.12))
                AxisValueLabel(format: .dateTime.hour(.defaultDigits(amPM: .abbreviated)))
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.6))
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.8, dash: [3, 5]))
                    .foregroundStyle(Color.white.opacity(0.07))
                AxisValueLabel {
                    if let temperature = value.as(Double.self) {
                        Text("\(Int(temperature.rounded()))°")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.42))
                    }
                }
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                updateSelection(at: value.location, proxy: proxy, geometry: geometry)
                            }
                    )
            }
        }
        .padding(.top, 4)
    }

    private func updateSelection(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        let frame = geometry[proxy.plotAreaFrame]
        let xPosition = location.x - frame.origin.x

        guard xPosition >= 0,
              xPosition <= proxy.plotAreaSize.width,
              let date: Date = proxy.value(atX: xPosition)
        else {
            return
        }

        selectedPoint = points.min { lhs, rhs in
            abs(lhs.date.timeIntervalSince(date)) < abs(rhs.date.timeIntervalSince(date))
        }
    }
}

private struct ForecastMetricChip: View {
    let icon: String
    let title: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(tint)

                Text(title)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.64))
            }

            Text(value)
                .font(.system(size: 16, weight: .black, design: .rounded))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.black.opacity(0.14))
        )
    }
}
