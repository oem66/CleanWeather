//
//  LocationManager.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 27. 2. 2024..
//

import Foundation
import CoreLocation

extension CLLocationManager {
    func getPlace(for location: CLLocation, completion: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                log.error(error)
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                log.error("Placemark could not be retrieved!")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
}
