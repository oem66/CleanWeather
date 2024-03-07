//
//  AirQualityViewModel.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 7. 3. 2024..
//

import Foundation
import CoreLocation

final class AirQualityViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var airQualityData = AirQualityResponseModel()
    @Published var location = CLLocation()
    
    private let useCase: AirQualityUseCaseProtocol
    
    private let locationManager = CLLocationManager()
    
    init(useCase: AirQualityUseCaseProtocol = AirQualityUseCase()) {
        self.useCase = useCase
    }
    
    func getAirQuality() async {
        getUserLocation()
        await Task.sleep(2_000_000_000)
        Task {
            log.verbose("CREATE MODEL")
            let model = AirQualityRequestModel(latitude: location.coordinate.latitude,
                                               longitude: location.coordinate.longitude)
            log.verbose("AQI Model: \(model)")
            if let data = await useCase.getAirQuality(model: model) {
                assignValueToAirQuality(data: data)
            }
        }
    }
    
    private func assignValueToAirQuality(data: AirQualityResponseModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.airQualityData = data
        }
    }
    
    func getUserLocation() {
        log.info("GET USER LOCATION")
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
