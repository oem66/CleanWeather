//
//  AirQualityRepository.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 7. 3. 2024..
//

import Foundation

final class AirQualityUseCase: AirQualityUseCaseProtocol {
    private lazy var repository = AirQualityRepository()
    
    func getAirQuality(model: AirQualityRequestModel) async -> AirQualityResponseModel? {
        return await repository.getAirQuality(model: model)
    }
}
