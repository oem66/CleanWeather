//
//  AirQualityRepositoryProtocol.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 7. 3. 2024..
//

import Foundation

protocol AirQualityRepositoryProtocol {
    func getAirQuality(model: AirQualityRequestModel) async -> AirQualityResponseModel?
}
