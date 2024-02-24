//
//  WeatherUseCase.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation

final class WeatherUseCase: WeatherUseCaseProtocol {
    private lazy var repository = WeatherRepository()
    
    func getWeather() {
        repository.getWeather()
    }
}
