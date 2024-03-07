//
//  AirQualityUseCaseProtocol.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 6. 3. 2024..
//

import Foundation

protocol AirQualityUseCaseProtocol {
    func getAirQuality(model: AirQualityRequestModel) async -> AirQualityResponseModel?
}
