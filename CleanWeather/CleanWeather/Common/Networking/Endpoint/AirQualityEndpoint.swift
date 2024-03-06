//
//  AirQualityEndpoint.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 6. 3. 2024..
//

import Foundation

enum AirQualityEndpoint {
    case aqi(model: AirQualityRequestModel)
}

extension AirQualityEndpoint: Endpoint {
    var host: String {
        switch self {
        case .aqi:
            return "https://api.openweathermap.org"
        }
    }
    
    var path: String {
        switch self {
        case .aqi:
            return "/data/2.5/air_pollution"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .aqi:
            return .GET
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .aqi:
            return nil
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .aqi(let model):
            return [
                "lat": "\(model.latitude)",
                "lon": "\(model.longitude)",
                "appid": "316c7a5589471defb540dbe6e1464c32"
            ]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .aqi:
            return nil
        }
    }
}
