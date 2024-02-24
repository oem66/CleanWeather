//
//  WeatherRepository.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation

final class WeatherRepository: WeatherRepositoryProtocol {
    private lazy var remoteRepository = WeatherRemoteRepository()
    
    func getWeather() {
        remoteRepository.getWeather()
    }
}
