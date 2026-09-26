//
//  APIError.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

public enum APIError: Error, LocalizedError {
    case invalidBaseURL
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, data: Data?)
    case transportError(Error)
    case decodingError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidBaseURL:
            return "The base URL provided is invalid."
        case .invalidURL:
            return "Could not construct a valid URL."
        case .invalidResponse:
            return "The server response was not a valid HTTP response."
        case .httpError(let statusCode, _):
            return "Request failed with status code \(statusCode)."
        case .transportError(let error):
            return "Network request failed: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}
