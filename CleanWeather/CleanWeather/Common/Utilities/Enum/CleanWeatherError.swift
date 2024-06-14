//
//  CleanWeatherError.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 14. 6. 2024..
//

import Foundation

enum CleanWeatherError: Error {
    
    case noUserId
    case noUserFound
    case selfNotFound
    case couldNotCastResponse
    case showGenericErrorMessage
    case badParameters
    case noDataFound
    case failedDatabaseUpdate
    case refreshTokenNotFound
    case noRefreshTokenRequest
    case refreshTokenResponseError
    case other(error: Error)

    public var description: String {
        switch self {
        case .noUserId: return "noUserId"
        case .noUserFound: return "noUserFound"
        case .selfNotFound: return "selfNotFound"
        case .couldNotCastResponse: return "couldNotCastResponse"
        case .showGenericErrorMessage: return "showGenericErrorMessage"
        case .badParameters: return "badParameters"
        case .noDataFound: return "noDataFound"
        case .failedDatabaseUpdate: return "failedDatabaseUpdate"
        case .refreshTokenNotFound: return "refreshTokenNotFound"
        case .noRefreshTokenRequest: return "noRefreshTokenRequest"
        case .refreshTokenResponseError: return "refreshTokenResponseErrror"
        case .other(let error):
            return error.localizedDescription
        }
    }
}

extension CleanWeatherError: Equatable {

    static func == (lhs: CleanWeatherError, rhs: CleanWeatherError) -> Bool {
        switch (lhs, rhs) {
        case (.noUserId, .noUserId): return true
        case (.noUserFound, .noUserFound): return true
        case (.selfNotFound, .selfNotFound): return true
        case (.couldNotCastResponse, .couldNotCastResponse): return true
        case (.showGenericErrorMessage, .showGenericErrorMessage): return true
        case (.badParameters, .badParameters): return true
        case (.noDataFound, .noDataFound): return true
        case (.failedDatabaseUpdate, .failedDatabaseUpdate): return true
        case (.refreshTokenNotFound, .refreshTokenNotFound): return true
        case (.noRefreshTokenRequest, .noRefreshTokenRequest): return true
        case (.other(let lhsOtherError),
              .other(let rhsOtherError)):
                return lhsOtherError.localizedDescription == rhsOtherError.localizedDescription
        default: return false
        }
    }
}
