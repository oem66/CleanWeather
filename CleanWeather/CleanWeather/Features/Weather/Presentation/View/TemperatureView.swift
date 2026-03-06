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
    @State private var showSheetView = false

    private var currentWeather: CurrentWeather? {
        viewModel.weatherData.currentWeather
    }

    private var todayForecast: DayWeatherConditions? {
        viewModel.weatherData.forecastDaily?.days.first
    }

    private var theme: WeatherSceneTheme {
        WeatherSceneTheme(
            condition: currentWeather?.conditionCode ?? "",
            daylight: currentWeather?.daylight ?? true
        )
    }

    private var citySeed: Int {
        let locationSeed = (viewModel.placemark + viewModel.country).utf8.reduce(0) { partialResult, scalar in
            partialResult + Int(scalar)
        }

        return locationSeed + Int((currentWeather?.temperature ?? 0) * 10)
    }

    private var temperatureText: String {
        guard let temperature = currentWeather?.temperature else {
            return "--°"
        }

        return "\(Int(temperature.rounded()))°"
    }

    private var feelsLikeText: String {
        guard let apparent = currentWeather?.temperatureApparent else {
            return "--°"
        }

        return "\(Int(apparent.rounded()))°"
    }

    private var highLowText: String {
        guard let todayForecast else {
            return "H --°  L --°"
        }

        return "H \(Int(todayForecast.temperatureMax.rounded()))°  L \(Int(todayForecast.temperatureMin.rounded()))°"
    }

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 34, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(theme.isNight ? 0.16 : 0.14),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 34, style: .continuous)
                            .strokeBorder(Color.white.opacity(theme.isNight ? 0.16 : 0.12), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.22), radius: 25, x: 0, y: 18)

                VStack(alignment: .leading, spacing: 22) {
                    header
                    heroVisual
                    temperatureDetails
                }
                .padding(22)
            }
            .fullScreenCover(isPresented: $showSheetView) {
                SelectLocationView(viewModel: viewModel, showSheetView: $showSheetView)
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.placemark.isEmpty ? "Current location" : viewModel.placemark)
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text(viewModel.country.isEmpty ? "Locating city" : viewModel.country.uppercased())
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .kerning(1.8)
                    .foregroundStyle(Color.white.opacity(0.72))

                Text(viewModel.currentDate.isEmpty ? Date.now.formatted(date: .abbreviated, time: .omitted) : viewModel.currentDate)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.82))
            }

            Spacer()

            Button {
                showSheetView.toggle()
            } label: {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [theme.accent.opacity(0.95), theme.secondaryAccent.opacity(0.86)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                }
                .frame(width: 52, height: 52)
                .shadow(color: theme.accent.opacity(0.32), radius: 12, x: 0, y: 10)
            }
            .buttonStyle(.plain)
        }
    }

    private var heroVisual: some View {
        ZStack(alignment: .topLeading) {
            WeatherHeroVisual(
                theme: theme,
                citySeed: citySeed,
                cloudCover: currentWeather?.cloudCover ?? 0,
                temperature: currentWeather?.temperature ?? 0
            )
            .frame(height: 290)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))

            if currentWeather == nil {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .padding(18)
            }
        }
    }

    private var temperatureDetails: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline, spacing: 14) {
                Text(temperatureText)
                    .font(.system(size: 74, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                VStack(alignment: .leading, spacing: 7) {
                    Text(currentWeather?.conditionCode ?? "Syncing local weather")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.92))
                        .lineLimit(2)

                    Text(highLowText)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.72))
                }
                .padding(.bottom, 10)
            }

            HStack(spacing: 10) {
                WeatherStatusPill(
                    label: "Feels Like",
                    value: feelsLikeText,
                    icon: "thermometer.medium",
                    accent: theme.accent
                )

                WeatherStatusPill(
                    label: "Wind",
                    value: "\(Int((currentWeather?.windSpeed ?? 0).rounded())) km/h",
                    icon: "wind",
                    accent: theme.secondaryAccent
                )

                WeatherStatusPill(
                    label: "Humidity",
                    value: "\(Int((currentWeather?.humidity ?? 0) * 100))%",
                    icon: "drop.fill",
                    accent: theme.windowGlow
                )
            }
        }
    }
}

private struct WeatherStatusPill: View {
    let label: String
    let value: String
    let icon: String
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(accent)

                Text(label)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.66))
                    .lineLimit(1)
            }

            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 14)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.black.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

private struct WeatherHeroVisual: View {
    let theme: WeatherSceneTheme
    let citySeed: Int
    let cloudCover: Double
    let temperature: Double

    var body: some View {
        GeometryReader { proxy in
            TimelineView(.animation(minimumInterval: 1.0 / 24.0, paused: false)) { timeline in
                let time = timeline.date.timeIntervalSinceReferenceDate
                let flash = theme.isStormy ? lightningOpacity(at: time, seed: citySeed) : 0

                ZStack {
                    LinearGradient(
                        colors: [theme.skyTop, theme.skyBottom, theme.horizon],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    Circle()
                        .fill(theme.glow.opacity(theme.isNight ? 0.18 : 0.28))
                        .frame(width: proxy.size.width * 0.8)
                        .blur(radius: 55)
                        .offset(x: theme.isNight ? proxy.size.width * 0.18 : -proxy.size.width * 0.14, y: -proxy.size.height * 0.22)

                    if theme.isNight {
                        NightSkyField(seed: citySeed, time: time)
                    }

                    SunMoonOrb(theme: theme)
                        .frame(width: proxy.size.width * 0.22, height: proxy.size.width * 0.22)
                        .offset(x: proxy.size.width * 0.23, y: 14)

                    CloudLayer(theme: theme, time: time, cloudCover: cloudCover)
                    WeatherParticleLayer(theme: theme, seed: citySeed, time: time)

                    IsometricCityScene(theme: theme, seed: citySeed, time: time, temperature: temperature)
                        .padding(.horizontal, 10)
                        .padding(.top, 54)

                    if theme.isStormy {
                        LightningBolt()
                            .fill(Color.white.opacity(0.65 + flash))
                            .frame(width: 44, height: 78)
                            .offset(x: proxy.size.width * 0.22, y: 26)
                            .shadow(color: Color.white.opacity(0.5 + flash), radius: 18, x: 0, y: 8)

                        Rectangle()
                            .fill(Color.white.opacity(flash * 0.22))
                    }
                }
                .drawingGroup()
            }
        }
    }

    private func lightningOpacity(at time: TimeInterval, seed: Int) -> Double {
        let wave = sin(time * 1.4 + Double(seed % 11))
        let pulse = max(0, wave - 0.96) * 18
        return min(pulse, 0.9)
    }
}

private struct SunMoonOrb: View {
    let theme: WeatherSceneTheme

    var body: some View {
        ZStack {
            Circle()
                .fill(theme.glow.opacity(theme.isNight ? 0.14 : 0.24))
                .blur(radius: 20)
                .scaleEffect(1.45)

            if theme.isNight {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.92), theme.windowGlow.opacity(0.74)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Circle()
                        .fill(theme.skyTop)
                        .frame(width: 38, height: 38)
                        .offset(x: 10, y: -8)
                }
            } else {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.white, theme.glow, theme.accent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                    )
            }
        }
    }
}

private struct NightSkyField: View {
    let seed: Int
    let time: TimeInterval

    var body: some View {
        GeometryReader { proxy in
            ForEach(0..<24, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.55 + (seededUnit(seed: seed, index: index) * 0.35)))
                    .frame(
                        width: 1.8 + seededUnit(seed: seed, index: index + 100) * 2.6,
                        height: 1.8 + seededUnit(seed: seed, index: index + 100) * 2.6
                    )
                    .blur(radius: 0.4)
                    .position(
                        x: proxy.size.width * seededUnit(seed: seed, index: index + 10),
                        y: proxy.size.height * (seededUnit(seed: seed, index: index + 40) * 0.48)
                    )
                    .opacity(0.45 + 0.3 * abs(sin(time * 0.7 + Double(index))))
            }
        }
    }
}

private struct CloudLayer: View {
    let theme: WeatherSceneTheme
    let time: TimeInterval
    let cloudCover: Double

    var body: some View {
        GeometryReader { proxy in
            let count = theme.cloudCount + (cloudCover > 0.55 ? 1 : 0)

            ForEach(0..<count, id: \.self) { index in
                let progress = CGFloat(index + 1) / CGFloat(max(count, 1))
                let y = proxy.size.height * (0.12 + (0.12 * progress))
                let drift = CGFloat(sin(time * (0.08 + Double(index) * 0.02) + Double(index))) * 18

                CloudCluster(opacity: theme.cloudOpacity, isStormy: theme.isStormy)
                    .frame(width: 96 + (progress * 90), height: 54 + (progress * 18))
                    .offset(x: drift, y: 0)
                    .position(
                        x: proxy.size.width * (0.18 + (progress * 0.62)),
                        y: y
                    )
            }

            if theme.hasFog {
                FogBands(theme: theme, time: time)
            }
        }
    }
}

private struct CloudCluster: View {
    let opacity: Double
    let isStormy: Bool

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Capsule()
                .fill(Color.white.opacity(opacity * (isStormy ? 0.44 : 0.56)))
                .frame(width: 86, height: 30)
                .offset(x: 16, y: 8)

            Circle()
                .fill(Color.white.opacity(opacity))
                .frame(width: 42, height: 42)
                .offset(x: 12, y: 0)

            Circle()
                .fill(Color.white.opacity(opacity * 0.92))
                .frame(width: 56, height: 56)
                .offset(x: 30, y: -8)

            Circle()
                .fill(Color.white.opacity(opacity * 0.84))
                .frame(width: 38, height: 38)
                .offset(x: 60, y: 2)
        }
        .blur(radius: isStormy ? 0.9 : 0.2)
    }
}

private struct FogBands: View {
    let theme: WeatherSceneTheme
    let time: TimeInterval

    var body: some View {
        VStack(spacing: 18) {
            ForEach(0..<3, id: \.self) { index in
                Capsule()
                    .fill(Color.white.opacity(0.14))
                    .frame(width: 210 + CGFloat(index * 35), height: 20)
                    .blur(radius: 8)
                    .offset(x: CGFloat(sin(time * 0.22 + Double(index))) * 22, y: CGFloat(index * 8))
            }
        }
        .padding(.top, 110)
    }
}

private struct WeatherParticleLayer: View {
    let theme: WeatherSceneTheme
    let seed: Int
    let time: TimeInterval

    var body: some View {
        Canvas { context, size in
            if theme.hasRain {
                drawRain(in: &context, size: size)
            }

            if theme.hasSnow {
                drawSnow(in: &context, size: size)
            }
        }
    }

    private func drawRain(in context: inout GraphicsContext, size: CGSize) {
        for index in 0..<74 {
            let x = size.width * seededUnit(seed: seed, index: index + 200)
            let speed = 160 + (seededUnit(seed: seed, index: index + 240) * 170)
            let originY = size.height * seededUnit(seed: seed, index: index + 280)
            let y = wrapped(value: originY + CGFloat(time) * speed, upperBound: size.height + 34) - 24
            let length = 12 + seededUnit(seed: seed, index: index + 320) * 18

            var path = Path()
            path.move(to: CGPoint(x: x, y: y))
            path.addLine(to: CGPoint(x: x - 8, y: y + length))

            context.stroke(
                path,
                with: .color(theme.secondaryAccent.opacity(theme.isStormy ? 0.78 : 0.56)),
                style: StrokeStyle(lineWidth: theme.isStormy ? 1.8 : 1.2, lineCap: .round)
            )
        }
    }

    private func drawSnow(in context: inout GraphicsContext, size: CGSize) {
        for index in 0..<46 {
            let progress = seededUnit(seed: seed, index: index + 400)
            let baseX = size.width * progress
            let amplitude = 10 + seededUnit(seed: seed, index: index + 450) * 12
            let speed = 28 + seededUnit(seed: seed, index: index + 500) * 24
            let radius = 2 + seededUnit(seed: seed, index: index + 520) * 2.8
            let startY = size.height * seededUnit(seed: seed, index: index + 560)
            let y = wrapped(value: startY + CGFloat(time) * speed, upperBound: size.height + 20) - 12
            let x = baseX + CGFloat(sin(time * 0.8 + Double(index))) * amplitude

            let rect = CGRect(x: x, y: y, width: radius, height: radius)
            context.fill(Path(ellipseIn: rect), with: .color(Color.white.opacity(0.88)))
        }
    }

    private func wrapped(value: CGFloat, upperBound: CGFloat) -> CGFloat {
        guard upperBound > 0 else { return value }
        return value.truncatingRemainder(dividingBy: upperBound)
    }
}

private struct IsometricCityScene: View {
    let theme: WeatherSceneTheme
    let seed: Int
    let time: TimeInterval
    let temperature: Double

    var body: some View {
        GeometryReader { proxy in
            let tileWidth = max(28, proxy.size.width * 0.12)
            let tileDepth = max(24, proxy.size.width * 0.1)
            let baseAnchor = CGPoint(x: proxy.size.width * 0.48, y: proxy.size.height * 0.18)
            let tiles = generatedTiles(baseAnchor: baseAnchor, tileWidth: tileWidth, tileDepth: tileDepth)
            let buildings = generatedBuildings(from: tiles, tileWidth: tileWidth, tileDepth: tileDepth, in: proxy.size)

            ZStack {
                ForEach(tiles) { tile in
                    IsometricGroundTile(theme: theme, tile: tile)
                }

                ForEach(buildings) { building in
                    IsometricBuilding(theme: theme, building: building, time: time)
                }

                Capsule()
                    .fill(theme.cityBase.opacity(theme.isNight ? 0.36 : 0.26))
                    .frame(width: proxy.size.width * 0.52, height: 22)
                    .blur(radius: 14)
                    .offset(x: 0, y: proxy.size.height * 0.34)
            }
            .offset(y: 8 + CGFloat(min(abs(temperature), 24)) * -0.08)
        }
    }

    private func generatedTiles(baseAnchor: CGPoint, tileWidth: CGFloat, tileDepth: CGFloat) -> [CityTileModel] {
        let right = CGVector(dx: tileWidth, dy: tileWidth * 0.34)
        let left = CGVector(dx: -tileDepth, dy: tileDepth * 0.34)
        var items: [CityTileModel] = []
        var identifier = 0

        for row in 0..<4 {
            for column in 0..<5 {
                let anchor = baseAnchor + (right * (CGFloat(column) * 0.84)) + (left * (CGFloat(row) * 0.84))
                items.append(
                    CityTileModel(
                        id: identifier,
                        anchor: anchor,
                        width: tileWidth,
                        depth: tileDepth
                    )
                )
                identifier += 1
            }
        }

        return items.sorted { $0.anchor.y < $1.anchor.y }
    }

    private func generatedBuildings(from tiles: [CityTileModel], tileWidth: CGFloat, tileDepth: CGFloat, in size: CGSize) -> [CityBuildingModel] {
        var items: [CityBuildingModel] = []

        for tile in tiles {
            let chance = seededUnit(seed: seed, index: tile.id + 40)
            let priorityTile = tile.id == 2 || tile.id == 7 || tile.id == 12

            guard priorityTile || chance > 0.28 else {
                continue
            }

            let footprint = tileWidth * (0.42 + seededUnit(seed: seed, index: tile.id + 80) * 0.28)
            let depth = tileDepth * (0.44 + seededUnit(seed: seed, index: tile.id + 120) * 0.24)
            let heightScale = 1.1 + seededUnit(seed: seed, index: tile.id + 160) * 2.1
            let stormBoost: CGFloat = theme.isStormy ? 1.08 : 1
            let height = max(size.height * 0.08, size.height * 0.06 * heightScale * stormBoost)
            let glow = seededUnit(seed: seed, index: tile.id + 200) > 0.62

            items.append(
                CityBuildingModel(
                    id: tile.id,
                    anchor: tile.anchor,
                    width: footprint,
                    depth: depth,
                    height: height,
                    highlighted: glow
                )
            )
        }

        return items.sorted { $0.anchor.y < $1.anchor.y }
    }
}

private struct IsometricGroundTile: View {
    let theme: WeatherSceneTheme
    let tile: CityTileModel

    var body: some View {
        Path { path in
            let points = tile.topFacePoints
            path.move(to: points[0])
            path.addLines(Array(points.dropFirst()))
            path.closeSubpath()
        }
        .fill(
            LinearGradient(
                colors: [theme.roof.opacity(0.9), theme.cityBase.opacity(0.72)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            Path { path in
                let points = tile.topFacePoints
                path.move(to: points[0])
                path.addLines(Array(points.dropFirst()))
                path.closeSubpath()
            }
            .stroke(Color.white.opacity(0.08), lineWidth: 0.8)
        )
    }
}

private struct IsometricBuilding: View {
    let theme: WeatherSceneTheme
    let building: CityBuildingModel
    let time: TimeInterval

    var body: some View {
        let lift = CGFloat(sin(time * 0.4 + Double(building.id))) * 1.2
        let points = building.points(offsetY: lift)

        ZStack {
            Path { path in
                path.move(to: points.top[0])
                path.addLines(Array(points.top.dropFirst()))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    colors: [theme.roof, theme.roof.opacity(0.72)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

            Path { path in
                path.move(to: points.left[0])
                path.addLines(Array(points.left.dropFirst()))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    colors: [theme.buildingFront, theme.buildingFront.opacity(0.88)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            Path { path in
                path.move(to: points.right[0])
                path.addLines(Array(points.right.dropFirst()))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    colors: [theme.buildingSide, theme.buildingSide.opacity(0.82)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            Path { path in
                path.move(to: points.top[0])
                path.addLines(Array(points.top.dropFirst()))
                path.closeSubpath()
            }
            .stroke(Color.white.opacity(0.14), lineWidth: 1)

            if building.highlighted {
                Circle()
                    .fill(theme.windowGlow.opacity(theme.isNight ? 0.92 : 0.7))
                    .frame(width: 8, height: 8)
                    .position(points.top[2])
                    .shadow(color: theme.windowGlow.opacity(0.75), radius: 10, x: 0, y: 0)
            }
        }
        .shadow(color: Color.black.opacity(0.18), radius: 10, x: 0, y: 8)
    }
}

private struct LightningBolt: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX + rect.width * 0.08, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.28, y: rect.midY - rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.midX + rect.width * 0.04, y: rect.midY - rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.22, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.22, y: rect.midY + rect.height * 0.02))
        path.addLine(to: CGPoint(x: rect.midX + rect.width * 0.08, y: rect.midY + rect.height * 0.02))
        path.closeSubpath()
        return path
    }
}

struct WeatherSceneTheme {
    let kind: WeatherSceneKind
    let skyTop: Color
    let skyBottom: Color
    let horizon: Color
    let glow: Color
    let accent: Color
    let secondaryAccent: Color
    let cityBase: Color
    let roof: Color
    let buildingFront: Color
    let buildingSide: Color
    let windowGlow: Color

    init(condition: String, daylight: Bool) {
        let normalized = condition.lowercased()

        if normalized.contains("snow") || normalized.contains("flurr") || normalized.contains("sleet") || normalized.contains("wintry") || normalized.contains("blizzard") {
            kind = .snow
        } else if normalized.contains("thunder") || normalized.contains("storm") {
            kind = .storm
        } else if normalized.contains("rain") || normalized.contains("drizzle") || normalized.contains("shower") {
            kind = .rain
        } else if normalized.contains("fog") || normalized.contains("haze") || normalized.contains("smok") || normalized.contains("dust") {
            kind = .fog
        } else if normalized.contains("cloud") {
            kind = daylight ? .cloudyDay : .cloudyNight
        } else {
            kind = daylight ? .clearDay : .clearNight
        }

        switch kind {
        case .clearDay:
            skyTop = Color(red: 0.17, green: 0.47, blue: 0.96)
            skyBottom = Color(red: 0.44, green: 0.79, blue: 0.99)
            horizon = Color(red: 0.98, green: 0.82, blue: 0.54)
            glow = Color(red: 1.00, green: 0.86, blue: 0.46)
            accent = Color(red: 1.00, green: 0.63, blue: 0.19)
            secondaryAccent = Color(red: 0.19, green: 0.74, blue: 0.98)
            cityBase = Color(red: 0.22, green: 0.34, blue: 0.54)
            roof = Color(red: 0.58, green: 0.78, blue: 0.95)
            buildingFront = Color(red: 0.26, green: 0.39, blue: 0.63)
            buildingSide = Color(red: 0.18, green: 0.30, blue: 0.50)
            windowGlow = Color(red: 0.99, green: 0.82, blue: 0.46)
        case .clearNight:
            skyTop = Color(red: 0.03, green: 0.05, blue: 0.15)
            skyBottom = Color(red: 0.08, green: 0.12, blue: 0.28)
            horizon = Color(red: 0.14, green: 0.20, blue: 0.40)
            glow = Color(red: 0.71, green: 0.82, blue: 1.00)
            accent = Color(red: 0.31, green: 0.70, blue: 1.00)
            secondaryAccent = Color(red: 0.95, green: 0.64, blue: 0.30)
            cityBase = Color(red: 0.09, green: 0.12, blue: 0.24)
            roof = Color(red: 0.21, green: 0.27, blue: 0.46)
            buildingFront = Color(red: 0.11, green: 0.15, blue: 0.30)
            buildingSide = Color(red: 0.07, green: 0.10, blue: 0.22)
            windowGlow = Color(red: 0.99, green: 0.80, blue: 0.49)
        case .cloudyDay:
            skyTop = Color(red: 0.35, green: 0.46, blue: 0.62)
            skyBottom = Color(red: 0.55, green: 0.66, blue: 0.75)
            horizon = Color(red: 0.83, green: 0.84, blue: 0.80)
            glow = Color(red: 0.88, green: 0.91, blue: 0.96)
            accent = Color(red: 0.32, green: 0.72, blue: 0.94)
            secondaryAccent = Color(red: 0.90, green: 0.78, blue: 0.52)
            cityBase = Color(red: 0.24, green: 0.28, blue: 0.36)
            roof = Color(red: 0.63, green: 0.69, blue: 0.78)
            buildingFront = Color(red: 0.29, green: 0.35, blue: 0.46)
            buildingSide = Color(red: 0.20, green: 0.25, blue: 0.36)
            windowGlow = Color(red: 0.96, green: 0.82, blue: 0.55)
        case .cloudyNight:
            skyTop = Color(red: 0.05, green: 0.08, blue: 0.17)
            skyBottom = Color(red: 0.10, green: 0.16, blue: 0.28)
            horizon = Color(red: 0.18, green: 0.24, blue: 0.40)
            glow = Color(red: 0.82, green: 0.86, blue: 0.96)
            accent = Color(red: 0.38, green: 0.73, blue: 0.96)
            secondaryAccent = Color(red: 0.96, green: 0.72, blue: 0.45)
            cityBase = Color(red: 0.10, green: 0.13, blue: 0.22)
            roof = Color(red: 0.23, green: 0.29, blue: 0.39)
            buildingFront = Color(red: 0.11, green: 0.14, blue: 0.24)
            buildingSide = Color(red: 0.08, green: 0.11, blue: 0.19)
            windowGlow = Color(red: 1.00, green: 0.82, blue: 0.55)
        case .rain:
            skyTop = Color(red: 0.18, green: 0.24, blue: 0.34)
            skyBottom = Color(red: 0.28, green: 0.38, blue: 0.51)
            horizon = Color(red: 0.45, green: 0.53, blue: 0.61)
            glow = Color(red: 0.70, green: 0.84, blue: 0.96)
            accent = Color(red: 0.28, green: 0.82, blue: 0.91)
            secondaryAccent = Color(red: 0.66, green: 0.85, blue: 1.00)
            cityBase = Color(red: 0.15, green: 0.20, blue: 0.30)
            roof = Color(red: 0.36, green: 0.46, blue: 0.58)
            buildingFront = Color(red: 0.17, green: 0.24, blue: 0.36)
            buildingSide = Color(red: 0.12, green: 0.18, blue: 0.28)
            windowGlow = Color(red: 0.91, green: 0.96, blue: 1.00)
        case .storm:
            skyTop = Color(red: 0.08, green: 0.10, blue: 0.16)
            skyBottom = Color(red: 0.16, green: 0.20, blue: 0.28)
            horizon = Color(red: 0.26, green: 0.30, blue: 0.38)
            glow = Color(red: 0.63, green: 0.83, blue: 0.99)
            accent = Color(red: 0.39, green: 0.79, blue: 0.98)
            secondaryAccent = Color(red: 0.87, green: 0.93, blue: 1.00)
            cityBase = Color(red: 0.10, green: 0.12, blue: 0.20)
            roof = Color(red: 0.24, green: 0.28, blue: 0.36)
            buildingFront = Color(red: 0.10, green: 0.14, blue: 0.24)
            buildingSide = Color(red: 0.07, green: 0.09, blue: 0.16)
            windowGlow = Color(red: 0.88, green: 0.96, blue: 1.00)
        case .snow:
            skyTop = Color(red: 0.43, green: 0.56, blue: 0.72)
            skyBottom = Color(red: 0.73, green: 0.82, blue: 0.90)
            horizon = Color(red: 0.94, green: 0.96, blue: 0.98)
            glow = Color(red: 1.00, green: 1.00, blue: 1.00)
            accent = Color(red: 0.49, green: 0.78, blue: 0.93)
            secondaryAccent = Color(red: 0.95, green: 0.98, blue: 1.00)
            cityBase = Color(red: 0.36, green: 0.44, blue: 0.54)
            roof = Color(red: 0.91, green: 0.95, blue: 0.99)
            buildingFront = Color(red: 0.52, green: 0.60, blue: 0.72)
            buildingSide = Color(red: 0.40, green: 0.47, blue: 0.58)
            windowGlow = Color(red: 0.99, green: 0.86, blue: 0.63)
        case .fog:
            skyTop = Color(red: 0.47, green: 0.52, blue: 0.58)
            skyBottom = Color(red: 0.68, green: 0.72, blue: 0.75)
            horizon = Color(red: 0.84, green: 0.85, blue: 0.84)
            glow = Color(red: 0.95, green: 0.95, blue: 0.93)
            accent = Color(red: 0.57, green: 0.76, blue: 0.82)
            secondaryAccent = Color(red: 0.89, green: 0.90, blue: 0.84)
            cityBase = Color(red: 0.28, green: 0.31, blue: 0.34)
            roof = Color(red: 0.74, green: 0.77, blue: 0.80)
            buildingFront = Color(red: 0.40, green: 0.43, blue: 0.48)
            buildingSide = Color(red: 0.31, green: 0.34, blue: 0.38)
            windowGlow = Color(red: 0.98, green: 0.95, blue: 0.84)
        }
    }

    var isNight: Bool {
        kind == .clearNight || kind == .cloudyNight
    }

    var isStormy: Bool {
        kind == .storm
    }

    var hasRain: Bool {
        kind == .rain || kind == .storm
    }

    var hasSnow: Bool {
        kind == .snow
    }

    var hasFog: Bool {
        kind == .fog
    }

    var symbolName: String {
        switch kind {
        case .clearDay:
            return "sun.max.fill"
        case .clearNight:
            return "moon.stars.fill"
        case .cloudyDay:
            return "cloud.sun.fill"
        case .cloudyNight:
            return "cloud.moon.fill"
        case .rain:
            return "cloud.rain.fill"
        case .storm:
            return "cloud.bolt.rain.fill"
        case .snow:
            return "snowflake"
        case .fog:
            return "cloud.fog.fill"
        }
    }

    var cloudOpacity: Double {
        switch kind {
        case .storm:
            return 0.78
        case .rain, .cloudyDay, .cloudyNight, .fog:
            return 0.66
        case .snow:
            return 0.58
        case .clearDay, .clearNight:
            return 0.36
        }
    }

    var cloudCount: Int {
        switch kind {
        case .storm:
            return 4
        case .rain, .fog:
            return 3
        case .cloudyDay, .cloudyNight, .snow:
            return 2
        case .clearDay, .clearNight:
            return 1
        }
    }
}

enum WeatherSceneKind {
    case clearDay
    case clearNight
    case cloudyDay
    case cloudyNight
    case rain
    case storm
    case snow
    case fog
}

private struct CityTileModel: Identifiable {
    let id: Int
    let anchor: CGPoint
    let width: CGFloat
    let depth: CGFloat

    var topFacePoints: [CGPoint] {
        let right = CGVector(dx: width, dy: width * 0.34)
        let left = CGVector(dx: -depth, dy: depth * 0.34)
        let back = anchor
        let rightPoint = back + right
        let front = rightPoint + left
        let leftPoint = back + left
        return [back, rightPoint, front, leftPoint]
    }
}

private struct CityBuildingModel: Identifiable {
    let id: Int
    let anchor: CGPoint
    let width: CGFloat
    let depth: CGFloat
    let height: CGFloat
    let highlighted: Bool

    func points(offsetY: CGFloat) -> (top: [CGPoint], left: [CGPoint], right: [CGPoint]) {
        let rightVector = CGVector(dx: width, dy: width * 0.34)
        let leftVector = CGVector(dx: -depth, dy: depth * 0.34)
        let downVector = CGVector(dx: 0, dy: height)
        let backTop = CGPoint(x: anchor.x, y: anchor.y - height + offsetY)
        let rightTop = backTop + rightVector
        let leftTop = backTop + leftVector
        let frontTop = rightTop + leftVector
        let rightBottom = anchor + rightVector + CGVector(dx: 0, dy: offsetY)
        let leftBottom = anchor + leftVector + CGVector(dx: 0, dy: offsetY)
        let frontBottom = rightBottom + leftVector
        let _ = downVector

        return (
            top: [backTop, rightTop, frontTop, leftTop],
            left: [leftTop, frontTop, frontBottom, leftBottom],
            right: [rightTop, frontTop, frontBottom, rightBottom]
        )
    }
}

private func seededUnit(seed: Int, index: Int) -> CGFloat {
    let raw = sin(Double((seed * 97) + (index * 31))) * 43758.5453
    return CGFloat(raw - floor(raw))
}

private extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGVector) -> CGPoint {
        CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }
}

private extension CGVector {
    static func * (lhs: CGVector, rhs: CGFloat) -> CGVector {
        CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }

    static func + (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }
}
