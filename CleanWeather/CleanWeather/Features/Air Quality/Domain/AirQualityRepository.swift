//
//  AirQualityRepository.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 7. 3. 2024..
//

import Foundation

final class AirQualityRepository: AirQualityRepositoryProtocol {
    private lazy var remoteRepository = AirQualityRemoteRepository()
    
    func getAirQuality(model: AirQualityRequestModel) async -> AirQualityResponseModel? {
        return await remoteRepository.getAirQuality(model: model)
    }
}
