//
//  WeatherConditions.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 1. 3. 2024..
//

import Foundation

enum WeatherConditions: String, CaseIterable {
    // MARK: - Visibility properties
    case blowindDust
    case clear
    case cloudy
    case foggy
    case haze
    case mostlyClear
    case mostlyCloud
    case partlyCloudy
    case smoky
    // MARK: - Wind properties
    case breezy
    case windy
    // MARK: - Precipation properties
    case drizzle
    case heavyRain
    case isolatedThunderstorms
    case rain
    case sunShowers
    case scatteredThunderstorms
    case strongStorms
    case thunderstorms
    // MARK: - Hazardous properties
    case frigid
    case hail
    case hot
    // MARK: - Winter precipation properties
    case flurries
    case sleet
    case snow
    case sunFlurries
    case wintryMix
    // MARK: - Hazardous winter properties
    case blizzard
    case blowingSnow
    case freezingDrizzle
    case heavySnow
    // MARK: - Tropical hazard properties
    case hurricane
    case tropicalStorm
}
