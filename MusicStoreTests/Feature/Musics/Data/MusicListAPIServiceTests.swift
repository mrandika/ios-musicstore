//
//  MusicListAPIServiceTests.swift
//  MusicStoreTests
//
//  Created by Andika on 26/09/26.
//

import Testing
import Foundation
@testable import MusicStore

@Suite("MusicListAPIService")
struct MusicListAPIServiceTests {
    @Test("Uses /search as the endpoint")
    func endpointIsSearch() {
        let apiService = MusicListAPIService.search(term: "taylor swift")

        #expect(apiService.endpoint == "/search")
        #expect(apiService.service.endpoint == "/search")
    }

    @Test("Uses the GET HTTP method")
    func usesGetMethod() {
        let apiService = MusicListAPIService.search(term: "taylor swift")

        #expect(apiService.service.method == .get)
    }

    @Test("Requests songs with the term and song entity as query items")
    func buildsQueryItems() {
        let apiService = MusicListAPIService.search(term: "taylor swift")

        #expect(apiService.service.queryItems.count == 2)
        #expect(apiService.service.queryItems.contains(URLQueryItem(name: "term", value: "taylor swift")))
        #expect(apiService.service.queryItems.contains(URLQueryItem(name: "entity", value: "song")))
    }

    @Test("Passes the term through unchanged", arguments: [
        "blank space",
        "AC/DC",
        "taylor+swift",
        "beyoncé & jay-z",
        ""
    ])
    func passesTermThrough(term: String) throws {
        let apiService = MusicListAPIService.search(term: term)

        let termItem = try #require(apiService.service.queryItems.first { $0.name == "term" })
        #expect(termItem.value == term)
    }
}
