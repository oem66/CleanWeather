//
//  WeatherService.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation
import Combine
import CoreLocation
import WeatherKit

protocol AppleWeatherServiceProtocol {
    func getWeather() -> AnyPublisher<WeatherData, Error>
}

final class AppleWeatherService: HTTPClient, AppleWeatherServiceProtocol {
    func getWeather() -> AnyPublisher<WeatherData, Error> {
        let weatherData = Future<WeatherData, Error> { promise in
            
        }
        .eraseToAnyPublisher()
        return weatherData
    }
}
