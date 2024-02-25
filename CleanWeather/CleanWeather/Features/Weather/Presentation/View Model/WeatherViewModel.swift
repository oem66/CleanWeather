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
    @Published var weatherData = WeatherData()
    
    private let useCase: WeatherUseCaseProtocol
    
    private let locationManager = CLLocationManager()
    private let weatherService = WeatherService()
    
    init(useCase: WeatherUseCaseProtocol = WeatherUseCase()) {
        self.useCase = useCase
    }
    
    private func getWeather(location: CLLocation) {
        Task {
            weatherData = await useCase.getWeather(location: location)
            debugPrint("Apple Weather Data: \(String(describing: weatherData.currentWeather))")
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
