//
//  MusicsResponseTests.swift
//  MusicStoreTests
//
//  Created by Andika on 26/09/26.
//

import Testing
import Foundation
@testable import MusicStore

@Suite("MusicsResponse")
struct MusicsResponseTests {
    private static let validPayload = """
    {
        "resultCount": 2,
        "results": [
            {
                "trackId": 1440857781,
                "trackExplicitness": "notExplicit",
                "artistName": "Taylor Swift",
                "collectionName": "1989",
                "trackName": "Blank Space",
                "previewUrl": "https://audio.example.com/blank-space.m4a",
                "artworkUrl100": "https://artwork.example.com/blank-space/100x100bb.jpg"
            },
            {
                "trackId": 1440857782,
                "trackExplicitness": "explicit",
                "artistName": "Taylor Swift",
                "collectionName": "1989",
                "trackName": "Bad Blood",
                "previewUrl": "https://audio.example.com/bad-blood.m4a",
                "artworkUrl100": "https://artwork.example.com/bad-blood/100x100bb.jpg"
            }
        ]
    }
    """

    private func decode(_ json: String) throws -> MusicsResponse {
        try JSONDecoder().decode(MusicsResponse.self, from: Data(json.utf8))
    }

    @Test("Decodes resultCount and results from a valid payload")
    func decodesValidPayload() throws {
        let response = try decode(Self.validPayload)

        #expect(response.resultCount == 2)
        #expect(response.results.count == 2)
    }

    @Test("Decodes every field of a music result")
    func decodesMusicDataFields() throws {
        let response = try decode(Self.validPayload)
        let first = try #require(response.results.first)

        #expect(first.trackId == 1440857781)
        #expect(first.trackExplicitness == "notExplicit")
        #expect(first.artistName == "Taylor Swift")
        #expect(first.collectionName == "1989")
        #expect(first.trackName == "Blank Space")
        #expect(first.previewUrl == "https://audio.example.com/blank-space.m4a")
        #expect(first.artworkUrl100 == "https://artwork.example.com/blank-space/100x100bb.jpg")
    }

    @Test("Ignores unknown fields such as wrapperType, kind, and trackPrice")
    func ignoresUnknownFields() throws {
        let response = try decode(Self.validPayload)

        #expect(response.results.count == 2)
        #expect(response.results[1].trackName == "Bad Blood")
        #expect(response.results[1].trackExplicitness == "explicit")
    }

    @Test("Preserves the order of results")
    func preservesResultOrder() throws {
        let response = try decode(Self.validPayload)

        #expect(response.results.map(\.trackId) == [1440857781, 1440857782])
    }

    @Test("Decodes an empty results array")
    func decodesEmptyResults() throws {
        let response = try decode(#"{"resultCount":0,"results":[]}"#)

        #expect(response.resultCount == 0)
        #expect(response.results.isEmpty)
    }

    @Test("Throws a decoding error for malformed payloads", arguments: [
        #"{"results":[]}"#,
        #"{"resultCount":0}"#,
        #"{"resultCount":"two","results":[]}"#,
        #"{"resultCount":1,"results":[{"trackId":1,"trackExplicitness":"explicit","artistName":"A","collectionName":"C","trackName":"T","previewUrl":"P"}]}"#,
        #"{"resultCount":1,"results":[{"trackId":1,"trackExplicitness":"explicit","artistName":"A","collectionName":"C","trackName":"T","previewUrl":null,"artworkUrl100":"A"}]}"#
    ])
    func throwsForMalformedPayloads(json: String) {
        #expect(throws: DecodingError.self) {
            try decode(json)
        }
    }
}
