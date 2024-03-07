//
//  HTTPClient.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError> {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        
        if let params = endpoint.parameters{
            components.setQueryItems(with: params)
        }
        
        guard let url = components.url else {
            return .failure(.invalidURL)
        }
        
        log.info("URL: \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        log.info("REQUEST: \(request)")
        
        if let body = endpoint.body {
            log.info("Body: \(body)")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch let error {
                log.error("Error while parsing body into JSON! \(error)")
            }
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    log.info("JSON: \(json)")
                }
            } catch let error {
                log.error("Whoops, we cound not parse that data into JSON! \(error)")
            }
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                log.info("Response data: \(decodedResponse)")
                return .success(decodedResponse)
            case 300:
                return .failure(.multipleChoices)
            case 301:
                return .failure(.movedPermanently)
            case 304:
                return .failure(.notModified)
            case 400:
                return .failure(.badRequest)
            case 401:
                return .failure(.unauthorized)
            case 403:
                return .failure(.forbidden)
            case 404:
                return .failure(.notFound)
            case 409:
                return .failure(.conflict)
            case 500:
                return .failure(.internalServerError)
            case 505:
                return .failure(.httpVersionNotSupported)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
