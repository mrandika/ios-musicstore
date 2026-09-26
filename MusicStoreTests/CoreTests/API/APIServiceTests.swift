//
//  APIServiceTests.swift
//  MusicStoreTests
//
//  Created by Andika on 26/09/26.
//

import Testing
import Foundation
@testable import MusicStore

@Suite("APIService")
struct APIServiceTests {
    @Test("Initializes with provided endpoint, method, and query items")
    func initWithAllParams() {
        let service = APIService("/search", method: .get, queryItems: [URLQueryItem(name: "limit", value: "100")])

        #expect(service.endpoint == "/search")
        #expect(service.method == .get)
        #expect(service.queryItems == [URLQueryItem(name: "limit", value: "100")])
    }

    @Test("Defaults queryItems to empty dictionary when omitted")
    func defaultsQueryItemsToEmpty() {
        let service = APIService("/search", method: .get)

        #expect(service.queryItems.isEmpty)
    }

    @Test("Stores multiple query items correctly")
    func multipleQueryItems() {
        let service = APIService(
            "/search",
            method: .get,
            queryItems: [
                URLQueryItem(name: "term", value: "swift"),
                URLQueryItem(name: "entity", value: "song")
            ]
        )

        #expect(service.queryItems.count == 2)
        #expect(service.queryItems.contains(URLQueryItem(name: "term", value: "swift")))
        #expect(service.queryItems.contains(URLQueryItem(name: "entity", value: "song")))
    }

    @Test("Supports all HTTP methods", arguments: [
        HTTPMethod.get
    ])
    func supportsAllMethods(method: HTTPMethod) {
        let service = APIService("/resource", method: method)
        #expect(service.method == method)
    }
}
