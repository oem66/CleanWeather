//
//  WeatherEndpoint.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation

enum WeatherEndpoint {
    case getWeather(WeatherRequestModel)
}

extension WeatherEndpoint: Endpoint {
    var host: String {
        switch self {
        case .getWeather:
            return ""
        }
    }
    
    var path: String {
        switch self {
        case .getWeather:
            return ""
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .getWeather:
            return .GET
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .getWeather:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(5)"
            ]
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .getWeather(let model):
            return [
                "": ""
            ]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getWeather:
            return nil
        }
    }
}
