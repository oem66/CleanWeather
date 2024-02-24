//
//  WeatherViewModel.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation

final class WeatherViewModel: ObservableObject {
    private let useCase: WeatherUseCaseProtocol
    
    init(useCase: WeatherUseCaseProtocol = WeatherUseCase()) {
        self.useCase = useCase
    }
}

extension WeatherViewModel {
    func getAll() {
        useCase.getWeather()
    }
}
