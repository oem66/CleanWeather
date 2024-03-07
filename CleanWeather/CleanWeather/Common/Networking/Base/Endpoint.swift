//
//  Endpoint.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var parameters: [String: String]? { get }
    var body: [String: Any]? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }
}
