//
//  RequestError.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation

enum RequestError: Error {
    case ok // 200
        case created // 201
        case noContent // 204
        
        case multipleChoices // 300
        case movedPermanently // 301
        case notModified // 304
        
        case badRequest // 400
        case unauthorized // 401
        case forbidden // 403
        case notFound // 404
        case conflict // 409
        
        case internalServerError // 500
        case httpVersionNotSupported // 505
        
        case decode
        case invalidURL
        case noResponse
        case unexpectedStatusCode
        case unknown
        
        var customMessage: String {
            switch self {
            case .decode:
                return "Error occurred while decoding data"
            case .ok:
                return "The request has succeeded"
            case .created:
                return "The request has been fulfilled and resulted in a new resource being created"
            case .noContent:
                return "The server has fulfilled the request but does not need to return an entity-body, and might want to return updated metainformation"
            case .multipleChoices:
                return "The requested resource corresponds to any one of a set of representations, each with its own specific location, and agent- driven negotiation information (section 12) is being provided so that the user (or user agent) can select a preferred representation and redirect its request to that location."
            case .movedPermanently:
                return "The requested resource has been assigned a new permanent URI and any future references to this resource SHOULD use one of the returned URIs"
            case .notModified:
                return "If the client has performed a conditional GET request and access is allowed, but the document has not been modified, the server SHOULD respond with this status code"
            case .badRequest:
                return "The request could not be understood by the server due to malformed syntax"
            case .unauthorized:
                return "The request requires user authentication"
            case .forbidden:
                return "The server understood the request, but is refusing to fulfill it. You don't have permission to access this resource"
            case .notFound:
                return "Resource could not be found"
            case .conflict:
                return "The request could not be completed due to a conflict with the current state of the resource"
            case .internalServerError:
                return "The server encountered an unexpected condition which prevented it from fulfilling the request"
            case .httpVersionNotSupported:
                return "The server does not support, or refuses to support, the HTTP protocol version that was used in the request message"
            default:
                return "Unknown error"
            }
        }
}
