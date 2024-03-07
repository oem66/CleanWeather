//
//  AirQualityRemoteRepository.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 7. 3. 2024..
//

import Foundation
import CoreLocation
import Combine

final class AirQualityRemoteRepository {
    let network: AirQualityServiceProtocol
    
    init(network: AirQualityServiceProtocol = AirQualityService()) {
        self.network = network
    }
    
    func getAirQuality(model: AirQualityRequestModel) async -> AirQualityResponseModel? {
        let result = await network.getAirQuality(model: model)
        switch result {
        case .success(let success):
            return success
        case .failure(let failure):
            log.error(failure.localizedDescription)
        }
        return nil
    }
}
