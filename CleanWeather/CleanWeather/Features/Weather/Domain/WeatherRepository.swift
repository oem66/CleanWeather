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
    private lazy var localRepository = WeatherLocalRepository()
    private lazy var remoteRepository = WeatherRemoteRepository()
    
    func getWeather(location: CLLocation) async -> WeatherData {
        log.info("Repository")
        let weatherData = await remoteRepository.getWeather(location: location)
        localRepository.saveWeather(data: weatherData)
        return weatherData
        
//        return await remoteRepository.getWeather(location: location)
    }
    
    func getOfflineWeather(completion: @escaping (WeatherData) -> Void) {
        localRepository.getOfflineWeather { data in
            completion(data)
        }
    }
}
