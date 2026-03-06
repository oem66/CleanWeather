//
//  AirQualityResponseModel.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 6. 3. 2024..
//

import Foundation

struct AirQualityResponseModel: Decodable, Sendable {
    var coord: Coordinates?
    var list: [AirQuality]?
}

struct Coordinates: Decodable, Sendable {
    var lat: Double
    var lon: Double
}

struct AirQuality: Decodable, Sendable {
    var main: MainAQI?
    var components: AQIComponents?
}

struct MainAQI: Decodable, Sendable {
    var aqi: Int
}

struct AQIComponents: Decodable, Sendable {
    var co: Double
    var no: Double
    var no2: Double
    var o3: Double
    var so2: Double
    var pm2_5: Double
    var pm10: Double
    var nh3: Double
}
