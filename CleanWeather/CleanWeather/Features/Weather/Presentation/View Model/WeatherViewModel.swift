//
//  WeatherViewModel.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation
import CoreLocation
import WeatherKit

final class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let useCase: WeatherUseCaseProtocol
    
    private let locationManager = CLLocationManager()
    private let weatherService = WeatherService()
    
    init(useCase: WeatherUseCaseProtocol = WeatherUseCase()) {
        self.useCase = useCase
    }
    
    private func getWeather(location: CLLocation) {
        Task {
            do {
                let result = try await weatherService.weather(for: location)
                debugPrint("\(result.currentWeather)")
            } catch {
                debugPrint("Error occured while fetching Weather data. \(error.localizedDescription)")
            }
        }
    }
    
    func getUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        locationManager.stopUpdatingLocation()
        
        // MARK: - Get data from Apple Weather API
        getWeather(location: location)
    }
}

extension WeatherViewModel {
//    func getAll() {
//        useCase.getWeather()
//    }
}
