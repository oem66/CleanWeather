//
//  WeatherRepositoryProtocol.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation
import CoreLocation

protocol WeatherRepositoryProtocol {
    func getWeather(location: CLLocation) async -> WeatherData
    func getOfflineWeather(completion: @escaping (WeatherData) -> Void)
}
