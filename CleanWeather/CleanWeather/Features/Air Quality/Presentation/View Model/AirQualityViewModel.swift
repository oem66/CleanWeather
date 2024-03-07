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
        Task {
            let model = AirQualityRequestModel(latitude: location.coordinate.latitude,
                                               longitude: location.coordinate.longitude)
            guard let data = await useCase.getAirQuality(model: model) else { return }
            log.info("Air Quality Data: \(data)")
            assignValueToAirQuality(data: data)
        }
    }
    
    private func assignValueToAirQuality(data: AirQualityResponseModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.airQualityData = data
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
