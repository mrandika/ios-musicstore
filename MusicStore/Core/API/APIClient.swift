//
//  APIClient.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

public protocol APIClientProtocol: Sendable {
    func fetch<D: Decodable & Sendable>(
        baseUrl: String,
        _ provider: APIServiceProvider
    ) async throws -> D
}

public final class APIClient: APIClientProtocol {
    public static let shared = APIClient()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = .init()
    ) {
        self.session = session
        self.decoder = decoder
    }
    
    public func fetch<D: Decodable & Sendable>(
        baseUrl: String,
        _ provider: APIServiceProvider
    ) async throws -> D {
        // Check the baseUrl
        guard
            var components = URLComponents(string: baseUrl),
            let scheme = components.scheme, !scheme.isEmpty,
            let host = components.host, !host.isEmpty
        else {
            throw APIError.invalidBaseURL
        }
        
        // Append the service endpoint
        let servicePath = provider.service.endpoint
        components.path += servicePath
            .hasPrefix("/") ? servicePath : "/\(servicePath)"
        
        // Build query items
        if !provider.service.queryItems.isEmpty {
            components.queryItems = provider.service.queryItems
        }
        
        // Check the url after building the query items
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        // Build the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = provider.service.method.rawValue
        
        let data: Data
        let response: URLResponse
        
        // Fetch
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.transportError(error)
        }
        
        // Validate URLResponse
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        // Validate response code
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
        
        // Return the decoded response
        do {
            return try decoder.decode(D.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
