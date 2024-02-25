//
//  WeatherRepository.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation
import CoreLocation
import Combine

final class WeatherRepository: WeatherRepositoryProtocol {
    private lazy var remoteRepository = WeatherRemoteRepository()
    
    func getWeather(location: CLLocation) async -> WeatherData {
        debugPrint("Repository")
        return await remoteRepository.getWeather(location: location)
    }
}
