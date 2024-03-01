//
//  WeatherData.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation
import WeatherKit

struct WeatherData: Decodable {
    var currentWeather: CurrentWeather?
    var forecastDaily: DailyForecast?
    var forecastHourly: HourlyForecast?
    var forecastNextHour: NextHourForecast?
    var weatherAlerts: WeatherAlertCollection?
}

// MARK: - Current Weather
struct CurrentWeather: Decodable {
    var asOf: Date // The date and time.
    var cloudCover: Double // The percentage of the sky covered with clouds during the period, from 0 to 1.
    var conditionCode: String // An enumeration value indicating the condition at the time.
    var daylight: Bool // A Boolean value indicating whether there is daylight.
    var humidity: Double // The relative humidity, from 0 to 1.
    var precipitationIntensity: Double // The precipitation intensity, in millimeters per hour.
    var pressure: Double // The sea level air pressure, in millibars.
    var temperature: Double // The current temperature, in degrees Celsius.
    var temperatureApparent: Double // Feels like temperature.
    var uvIndex: Int // The level of ultraviolet radiation.
    var visibility: Double // The distance at which terrain is visible, in meters.
    var windDirection: Int // The direction of the wind, in degrees.
    var windGust: Double // The maximum wind gust speed, in kilometers per hour.
    var windSpeed: Double // The wind speed, in kilometers per hour.
}

// MARK: - Daily Forecast
struct DailyForecast: Hashable, Decodable {
    var days: [DayWeatherConditions]
    var learnMoreURL: String
}

struct DayWeatherConditions: Hashable, Decodable {
    var conditionCode: String
    var forecastEnd: Date
    var forecastStart: Date
    var maxUvIndex: Int
    var moonPhase: MoonPhase
    var moonrise: Date
    var moonset: Date
    var precipitationAmount: Double
    var precipitationChance: Double
    var snowfallAmount: Double
    var sunrise: Date
    var sunset: Date
    var temperatureMax: Double
    var temperatureMin: Double
}

//struct DayPartForecast: Decodable {
//    var cloudCover: Double
//    var conditionCode: String
//    var forecastEnd: Date
//    var forecastStart: Date
//    var humidity: Double
//    var precipitationAmount: Double
//    var precipitationChance: Double
//    var snowfallAmount: Double
//    var windDirection: Int
//    var windSpeed: Double
//}

struct MoonPhase: Hashable, Decodable {
    var value: String
}

struct PrecipitationType: Decodable {
    var value: String
}

// MARK: - Hourly Forecast
struct HourlyForecast: Decodable {
    var hours: [HourWeatherConditions]
}

struct HourWeatherConditions: Decodable {
    var cloudCover: Double
    var conditionCode: String
    var daylight: Bool
    var forecastStart: Date
    var humidity: Double
    var precipitationChance: Double
    var precipitationType: PrecipitationType
    var pressure: Double
    var pressureTrend: PressureTrend
    var snowfallIntensity: Double
    var temperature: Double
    var temperatureApparent: Double
    var uvIndex: Int
    var visibility: Double
    var windDirection: Int
    var windGust: Double
    var windSpeed: Double
    var precipitationAmount: Double
}

// MARK: - Next Hour Forecast
struct NextHourForecast: Decodable {
    var forecastEnd: Date
    var forecastStart: Date
    var minutes: ForecastMinute
    var summary: ForecastPeriodSummary
}

struct ForecastMinute: Decodable {
    var precipitationChance: Double
    var precipitationIntensity: Double
    var startTime: Date
}

struct ForecastPeriodSummary: Decodable {
    var condition: PrecipitationType
    var endTime: Date
    var precipitationChance: Double
    var precipitationIntensity: Double
    var startTime: Date
}

// MARK: Weather Alert
struct WeatherAlertCollection: Decodable {
    var alerts: [WeatherAlertSummary]
    var detailsUrl: String
}

struct WeatherAlertSummary: Decodable {
    var areaId: String
    var areaName: String
    var certainty: Certainty
    var countryCode: String
    var description: String
    var detailsUrl: String
    var effectiveTime: Date
    var eventEndTime: Date
    var eventOnsetTime: Date
    var expireTime: Date
    var id: UUID
    var issuedTime: Date
    var severity: Severity
    var source: String
    var urgency: Urgency
}

struct Certainty: Decodable {
    var value: String
}

struct Severity: Decodable {
    var value: String
}

struct Urgency: Decodable {
    var value: String
}
