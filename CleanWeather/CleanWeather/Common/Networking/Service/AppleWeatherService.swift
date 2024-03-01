//
//  WeatherService.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation
import Combine
import WeatherKit
import CoreLocation

protocol AppleWeatherServiceProtocol {
    func getAppleWeather(location: CLLocation) async -> WeatherData
}

final class AppleWeatherService: AppleWeatherServiceProtocol {
    private let service = WeatherService()
    
    func getAppleWeather(location: CLLocation) async -> WeatherData {
        do {
            let result = try await self.service.weather(for: location)
            
            var dayWeatherConditions = [DayWeatherConditions]()
            for forecast in result.dailyForecast {
                dayWeatherConditions.append(DayWeatherConditions(conditionCode: forecast.condition.description,
                                                                 forecastEnd: Date(),
                                                                 forecastStart: Date(),
                                                                 maxUvIndex: forecast.uvIndex.value,
                                                                 moonPhase: MoonPhase(value: forecast.moon.phase.description),
                                                                 moonrise: forecast.moon.moonrise ?? Date(),
                                                                 moonset: forecast.moon.moonset ?? Date(),
                                                                 precipitationAmount: forecast.precipitationAmount.value,
                                                                 precipitationChance: forecast.precipitationChance,
                                                                 snowfallAmount: forecast.snowfallAmount.value,
                                                                 sunrise: forecast.sun.sunrise ?? Date(),
                                                                 sunset: forecast.sun.sunset ?? Date(),
                                                                 temperatureMax: forecast.highTemperature.value,
                                                                 temperatureMin: forecast.lowTemperature.value))
            }
            
            let weatherData = WeatherData(currentWeather: CurrentWeather(asOf: result.currentWeather.date,
                                                                         cloudCover: result.currentWeather.cloudCover,
                                                                         conditionCode: result.currentWeather.condition.description,
                                                                         daylight: result.currentWeather.isDaylight,
                                                                         humidity: result.currentWeather.humidity,
                                                                         precipitationIntensity: result.currentWeather.precipitationIntensity.value,
                                                                         pressure: result.currentWeather.pressure.value,
                                                                         temperature: Double(result.currentWeather.temperature.value),
                                                                         temperatureApparent: result.currentWeather.apparentTemperature.value,
                                                                         uvIndex: result.currentWeather.uvIndex.value,
                                                                         visibility: result.currentWeather.visibility.value,
                                                                         windDirection: Int(result.currentWeather.wind.direction.value),
                                                                         windGust: result.currentWeather.wind.gust?.value ?? 0.0,
                                                                         windSpeed: result.currentWeather.wind.speed.value),
                                          forecastDaily: DailyForecast(days: dayWeatherConditions,
                                                                       learnMoreURL: ""))
            log.info("Service Weather data \(weatherData)")
            return weatherData
        } catch {
            log.error("Error occured while fetching Weather data. \(error.localizedDescription)")
            return WeatherData()
        }
    }
}
