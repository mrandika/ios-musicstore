//
//  APIService.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

public protocol APIServiceProvider: Sendable {
    var endpoint: String { get }
    var service: APIService { get }
}

public struct APIService: Sendable {
    public let endpoint: String
    public let method: HTTPMethod
    public let queryItems: [URLQueryItem]

    public init(
        _ endpoint: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.method = method
        self.queryItems = queryItems
    }
}
