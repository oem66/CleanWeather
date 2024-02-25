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
    @Published var location = CLLocation()
    
    private let useCase: WeatherUseCaseProtocol
    
    private let locationManager = CLLocationManager()
    private let weatherService = WeatherService()
    
    init(useCase: WeatherUseCaseProtocol = WeatherUseCase()) {
        self.useCase = useCase
    }
    
    func getWeather(location: CLLocation) async {
        Task {
            let data = await useCase.getWeather(location: location)
            assignValueToWeather(data: data)
        }
    }
    
    private func assignValueToWeather(data: WeatherData) {
        DispatchQueue.main.async {
            self.weatherData = data
            debugPrint("View Model Data: \(self.weatherData.currentWeather)")
        }
    }
    
    func getUserLocation() async {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        locationManager.stopUpdatingLocation()
        
        self.location = location
    }
}
