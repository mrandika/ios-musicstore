//
//  APIService.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

protocol APIServiceProvider: Sendable {
    var endpoint: String { get }
    var service: APIService { get }
}

struct APIService: Sendable {
    public let endpoint: String
    public let method: HTTPMethod
    public let queryItems: [String: String]

    public init(
        _ endpoint: String,
        method: HTTPMethod,
        queryItems: [String: String] = [:]
    ) {
        self.endpoint = endpoint
        self.method = method
        self.queryItems = queryItems
    }
}
