//
//  AirQualityResponseModel.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 6. 3. 2024..
//

import Foundation

struct AirQualityResponseModel: Decodable {
    var coord: Coordinates?
    var list: AirQuality?
}

struct Coordinates: Decodable {
    var lat: Double
    var lon: Double
}

struct AirQuality: Decodable {
    var main: MainAQI
    var components: AQIComponents
}

struct MainAQI: Decodable {
    var aqi: Int
}

struct AQIComponents: Decodable {
    var co: Double
    var no: Double
    var no2: Double
    var o3: Double
    var so2: Double
    var pm2_5: Double
    var pm10: Double
    var nh3: Double
}
