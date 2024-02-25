//
//  WeatherUseCase.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation
import CoreLocation

final class WeatherUseCase: WeatherUseCaseProtocol {
    private lazy var repository = WeatherRepository()
    
    func getWeather(location: CLLocation) async -> WeatherData {
        debugPrint("Use Case")
        return await repository.getWeather(location: location)
    }
}
