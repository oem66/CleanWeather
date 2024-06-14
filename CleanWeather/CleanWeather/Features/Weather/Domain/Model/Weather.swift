//
//  Weather.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation

struct Weather: Equatable, Hashable {
    let asOf: Date
    let cloudCover: Double
    let conditionCode: String
    let daylight: Bool
    let humidity: Double
    let precipitationIntensity: Double
    let pressure: Double
    let temperature: Double
    let temperatureApparent: Double
    let uvIndex: Int
    let visibility: Double
    let windDirection: Int
    let windGust: Double
    let windSpeed: Double
}
