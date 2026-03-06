//
//  AirQualityViewModel.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 7. 3. 2024..
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

enum CityScale: String, CaseIterable, Sendable {
    case large
    case smaller

    var title: String {
        switch self {
        case .large:
            return "Large Cities"
        case .smaller:
            return "Smaller Cities"
        }
    }
}

struct CityPreset: Identifiable, Equatable, Sendable {
    let id: String
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
    let scale: CityScale

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }

    static let majorCities: [CityPreset] = [
        CityPreset(id: "new-york", name: "New York", country: "United States", latitude: 40.7128, longitude: -74.0060, scale: .large),
        CityPreset(id: "tokyo", name: "Tokyo", country: "Japan", latitude: 35.6764, longitude: 139.6500, scale: .large),
        CityPreset(id: "london", name: "London", country: "United Kingdom", latitude: 51.5072, longitude: -0.1276, scale: .large),
        CityPreset(id: "dubai", name: "Dubai", country: "United Arab Emirates", latitude: 25.2048, longitude: 55.2708, scale: .large),
        CityPreset(id: "singapore", name: "Singapore", country: "Singapore", latitude: 1.3521, longitude: 103.8198, scale: .large)
    ]

    static let smallerCities: [CityPreset] = [
        CityPreset(id: "mostar", name: "Mostar", country: "Bosnia and Herzegovina", latitude: 43.3438, longitude: 17.8078, scale: .smaller),
        CityPreset(id: "bled", name: "Bled", country: "Slovenia", latitude: 46.3692, longitude: 14.1136, scale: .smaller),
        CityPreset(id: "hallstatt", name: "Hallstatt", country: "Austria", latitude: 47.5622, longitude: 13.6493, scale: .smaller),
        CityPreset(id: "interlaken", name: "Interlaken", country: "Switzerland", latitude: 46.6863, longitude: 7.8632, scale: .smaller),
        CityPreset(id: "tromso", name: "Tromso", country: "Norway", latitude: 69.6492, longitude: 18.9553, scale: .smaller)
    ]

    static let featuredCities: [CityPreset] = majorCities + smallerCities
}

enum AQIBand: String, Sendable {
    case excellent
    case good
    case moderate
    case poor
    case severe

    init(value: Int) {
        switch value {
        case 1:
            self = .excellent
        case 2:
            self = .good
        case 3:
            self = .moderate
        case 4:
            self = .poor
        default:
            self = .severe
        }
    }

    var title: String {
        switch self {
        case .excellent:
            return "Excellent"
        case .good:
            return "Good"
        case .moderate:
            return "Moderate"
        case .poor:
            return "Poor"
        case .severe:
            return "Severe"
        }
    }

    var color: Color {
        switch self {
        case .excellent:
            return Constants.aqiGood
        case .good:
            return Color(red: 0.45, green: 0.83, blue: 0.37)
        case .moderate:
            return Constants.aqiUnhealthySensitiveGroups
        case .poor:
            return Constants.aqiUnhealthy
        case .severe:
            return Constants.aqiVeryUnhealthy
        }
    }
}

struct CitySnapshot: Identifiable, Sendable {
    let preset: CityPreset
    let weatherData: WeatherData
    let airQualityData: AirQualityResponseModel?
    let updatedAt: Date

    var id: String { preset.id }
    var coordinate: CLLocationCoordinate2D { preset.coordinate }
    var currentWeather: CurrentWeather? { weatherData.currentWeather }
    var currentTemperature: Double { currentWeather?.temperature ?? 0 }
    var currentPressure: Double { currentWeather?.pressure ?? 0 }
    var currentWindSpeed: Double { currentWeather?.windSpeed ?? 0 }
    var humidity: Double { currentWeather?.humidity ?? 0 }
    var conditionCode: String { currentWeather?.conditionCode ?? "Unavailable" }
    var daylight: Bool { currentWeather?.daylight ?? true }
    var theme: WeatherSceneTheme { WeatherSceneTheme(condition: conditionCode, daylight: daylight) }
    var formattedTemperature: String { "\(Int(currentTemperature.rounded()))°" }
    var formattedPressure: String { "\(Int(currentPressure.rounded())) mb" }
    var formattedWind: String { "\(Int(currentWindSpeed.rounded())) km/h" }
    var formattedHumidity: String { "\(Int((humidity * 100).rounded()))%" }
    var aqiValue: Int { airQualityData?.list?.first?.main?.aqi ?? 0 }
    var aqiBand: AQIBand { AQIBand(value: max(1, aqiValue)) }
    var airComponents: AQIComponents? { airQualityData?.list?.first?.components }
}

@MainActor
final class CityExplorerViewModel: ObservableObject {
    @Published private(set) var citySnapshots: [CitySnapshot] = []
    @Published private(set) var isLoading = false
    @Published var selectedCityID: String?
    @Published var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 47.4979, longitude: 19.0402),
        span: MKCoordinateSpan(latitudeDelta: 55, longitudeDelta: 55)
    )

    private var hasLoaded = false

    var selectedCity: CitySnapshot? {
        citySnapshots.first(where: { $0.id == selectedCityID }) ?? citySnapshots.first
    }

    var majorCities: [CitySnapshot] {
        citySnapshots.filter { $0.preset.scale == .large }
    }

    var smallerCities: [CitySnapshot] {
        citySnapshots.filter { $0.preset.scale == .smaller }
    }

    func loadIfNeeded() async {
        guard !hasLoaded else {
            return
        }

        hasLoaded = true
        await refresh()
    }

    func refresh() async {
        guard !isLoading else {
            return
        }

        isLoading = true
        let existingSelection = selectedCityID

        let snapshots = await withTaskGroup(of: CitySnapshot.self, returning: [CitySnapshot].self) { group in
            for preset in CityPreset.featuredCities {
                group.addTask {
                    await Self.fetchSnapshot(for: preset)
                }
            }

            var loaded: [CitySnapshot] = []
            for await snapshot in group {
                loaded.append(snapshot)
            }

            return loaded.sorted { lhs, rhs in
                if lhs.preset.scale == rhs.preset.scale {
                    return lhs.currentTemperature > rhs.currentTemperature
                }

                return lhs.preset.scale == .large
            }
        }

        citySnapshots = snapshots
        isLoading = false

        if let existingSelection,
           let match = citySnapshots.first(where: { $0.id == existingSelection }) {
            select(match)
        } else if let first = citySnapshots.first {
            select(first)
        }
    }

    func select(_ snapshot: CitySnapshot) {
        selectedCityID = snapshot.id

        withAnimation(.easeInOut(duration: 0.38)) {
            mapRegion = MKCoordinateRegion(
                center: snapshot.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: snapshot.preset.scale == .large ? 4.8 : 2.6,
                    longitudeDelta: snapshot.preset.scale == .large ? 4.8 : 2.6
                )
            )
        }
    }

    private static func fetchSnapshot(for preset: CityPreset) async -> CitySnapshot {
        async let weatherData = AppleWeatherService().getAppleWeather(location: preset.location)
        async let airQualityResult = AirQualityService().getAirQuality(
            model: AirQualityRequestModel(latitude: preset.latitude, longitude: preset.longitude)
        )

        let weather = await weatherData
        let airQuality: AirQualityResponseModel?

        switch await airQualityResult {
        case .success(let response):
            airQuality = response
        case .failure(let error):
            log.error("Failed air quality fetch for \(preset.name): \(error.localizedDescription)")
            airQuality = nil
        }

        return CitySnapshot(
            preset: preset,
            weatherData: weather,
            airQualityData: airQuality,
            updatedAt: Date()
        )
    }
}
