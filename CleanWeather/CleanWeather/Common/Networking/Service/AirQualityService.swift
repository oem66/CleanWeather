//
//  AirQualityService.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 6. 3. 2024..
//

import Foundation
import CoreLocation

protocol AirQualityServiceProtocol {
    func getAirQuality(model: AirQualityRequestModel) async -> Result<AirQualityResponseModel, RequestError>
}

final class AirQualityService: HTTPClient, AirQualityServiceProtocol {
    func getAirQuality(model: AirQualityRequestModel) async -> Result<AirQualityResponseModel, RequestError> {
        return await sendRequest(endpoint: AirQualityEndpoint.aqi(model: model), responseModel: AirQualityResponseModel.self)
    }
}
