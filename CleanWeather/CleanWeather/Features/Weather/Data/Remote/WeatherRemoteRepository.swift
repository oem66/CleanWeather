//
//  WeatherRemoteRepository.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation
import CoreLocation
import Combine

final class WeatherRemoteRepository {
    
    let network: AppleWeatherServiceProtocol!
    
    init(network: AppleWeatherServiceProtocol = AppleWeatherService()) {
        self.network = network
    }
    
    func getWeather(location: CLLocation) async -> WeatherData {
        debugPrint("Remote Repository")
        return network.getAppleWeather(location: location)
    }
}
