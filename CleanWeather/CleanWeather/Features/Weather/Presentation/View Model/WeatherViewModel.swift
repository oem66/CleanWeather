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
    @Published var placemark = ""
    @Published var country = ""
    @Published var currentDate = ""
    @Published var showLocationSelectionView = false
    @Published var weatherSymbol = "sun.max"
    
    // Search location properties
    @Published var cityName = ""
    @Published var coordinates: CLLocationCoordinate2D?
    @Published var locationName = ""
    
    private let useCase: WeatherUseCaseProtocol
    
    private let locationManager = CLLocationManager()
    private let weatherService = WeatherService()
    
    init(useCase: WeatherUseCaseProtocol = WeatherUseCase()) {
        self.useCase = useCase
    }
    
    func formatDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, EEEE"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        currentDate = dateFormatter.string(from: Date())
    }
    
    func fetchCoordinates() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { placemarks, error in
            if let error = error {
                print("Geocoding failed with error: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first,
               let location = placemark.location {
                self.coordinates = location.coordinate
                self.locationName = placemark.locality ?? "Unknown Location"
            }
        }
    }
    
    private func getWeather(location: CLLocation) async {
        Task {
            let data = await useCase.getWeather(location: location)
            assignValueToWeather(data: data)
        }
    }
    
    private func assignValueToWeather(data: WeatherData) {
        DispatchQueue.main.async {
            self.weatherData = data
            if let weatherCondition = data.currentWeather?.conditionCode {
                self.setWeatherSymbol(weatherCondition: weatherCondition)
            }
        }
    }
    
    private func setWeatherSymbol(weatherCondition: String) {
        if weatherCondition == "Clear" {
            weatherSymbol = "sun.max"
        } else if weatherCondition == "Mostly Clear" {
            weatherSymbol = "sun.min"
        } else if weatherCondition == "Partly Cloudy" {
            weatherSymbol = "cloud.sun"
        } else if weatherCondition == "Mostly Cloudy" {
            weatherSymbol = "cloud"
        } else if weatherCondition == "Cloudy" {
            weatherSymbol = "cloud"
        } else if weatherCondition == "Hazy" {
            weatherSymbol = "sun.haze"
        } else if weatherCondition == "Scattered Thunderstorms" {
            weatherSymbol = "cloud.sun.bolt"
        } else if weatherCondition == "Drizzle" {
            weatherSymbol = "cloud.drizzle"
        } else if weatherCondition == "Rain" {
            weatherSymbol = "cloud.rain"
        } else if weatherCondition == "Heavy Rain" {
            weatherSymbol = "cloud.heavyrain"
        }
    }
    
    func setWeatherSymbolToDailyForecast(weatherCondition: String) -> String {
        if weatherCondition == "Clear" {
            return "sun.max"
        } else if weatherCondition == "Mostly Clear" {
            return "sun.min"
        } else if weatherCondition == "Partly Cloudy" {
            return "cloud.sun"
        } else if weatherCondition == "Mostly Cloudy" {
            return "cloud"
        } else if weatherCondition == "Cloudy" {
            return "cloud"
        } else if weatherCondition == "Hazy" {
            return "sun.haze"
        } else if weatherCondition == "Scattered Thunderstorms" {
            return "cloud.sun.bolt"
        } else if weatherCondition == "Drizzle" {
            return "cloud.drizzle"
        } else if weatherCondition == "Rain" {
            return "cloud.rain"
        } else if weatherCondition == "Heavy Rain" {
            return "cloud.heavyrain"
        }
        return "sun.max"
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
        
        locationManager.getPlace(for: location) { [weak self] place in
            guard let self else { return }
            log.verbose("Country: \(String(describing: place?.country))")
            log.verbose("City: \(String(describing: place?.locality))")
            if let country = place?.country,
               let city = place?.locality {
                self.placemark = "\(city)"
                self.country = country
            }
        }
        
        Task {
            await getWeather(location: location)
        }
    }
}
