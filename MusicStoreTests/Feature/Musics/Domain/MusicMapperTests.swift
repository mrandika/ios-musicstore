//
//  MusicMapperTests.swift
//  MusicStoreTests
//
//  Created by Andika on 26/09/26.
//

import Testing
import Foundation
@testable import MusicStore

@Suite("MusicMapper")
struct MusicMapperTests {
    private let mapper = MusicMapper()

    private func makeData(
        trackId: Int = 1440857781,
        trackExplicitness: String = "notExplicit",
        artistName: String = "Taylor Swift",
        collectionName: String = "1989",
        trackName: String = "Blank Space",
        previewUrl: String = "https://audio.example.com/blank-space.m4a",
        artworkUrl100: String = "https://artwork.example.com/blank-space/100x100bb.jpg"
    ) -> MusicDataResponse {
        MusicDataResponse(
            trackId: trackId,
            trackExplicitness: trackExplicitness,
            artistName: artistName,
            collectionName: collectionName,
            trackName: trackName,
            previewUrl: previewUrl,
            artworkUrl100: artworkUrl100
        )
    }

    @Test("Maps every field of the response onto the model")
    func mapsAllFields() throws {
        let response = MusicsResponse(resultCount: 1, results: [makeData()])

        let models = mapper.transformResponseToModel(response: response)
        let music = try #require(models.first)

        #expect(music.id == 1440857781)
        #expect(music.artistName == "Taylor Swift")
        #expect(music.collectionName == "1989")
        #expect(music.trackName == "Blank Space")
        #expect(music.previewLink == "https://audio.example.com/blank-space.m4a")
        #expect(music.artworkLink == "https://artwork.example.com/blank-space/100x100bb.jpg")
    }

    @Test("Maps trackExplicitness to isExplicit", arguments: [
        ("explicit", true),
        ("cleaned", true),
        ("notExplicit", false)
    ])
    func mapsExplicitness(trackExplicitness: String, isExplicit: Bool) throws {
        let response = MusicsResponse(
            resultCount: 1,
            results: [makeData(trackExplicitness: trackExplicitness)]
        )

        let models = mapper.transformResponseToModel(response: response)

        #expect(models.first?.isExplicit == isExplicit)
    }

    @Test("Returns an empty model for an empty results array")
    func returnsEmptyModelForEmptyResults() {
        let response = MusicsResponse(resultCount: 0, results: [])

        let models = mapper.transformResponseToModel(response: response)

        #expect(models.isEmpty)
    }

    @Test("Maps one model per result, ignoring resultCount")
    func mapsOneModelPerResult() {
        let response = MusicsResponse(
            resultCount: 99,
            results: [makeData(trackId: 1), makeData(trackId: 2)]
        )

        let models = mapper.transformResponseToModel(response: response)

        #expect(models.count == 2)
    }

    @Test("Preserves the order of the results")
    func preservesOrder() {
        let response = MusicsResponse(
            resultCount: 3,
            results: [
                makeData(trackId: 1, trackName: "First"),
                makeData(trackId: 2, trackName: "Second"),
                makeData(trackId: 3, trackName: "Third")
            ]
        )

        let models = mapper.transformResponseToModel(response: response)

        #expect(models.map(\.id) == [1, 2, 3])
        #expect(models.map(\.trackName) == ["First", "Second", "Third"])
    }

    @Test("Produces playable preview and artwork URLs")
    func producesValidURLs() throws {
        let response = MusicsResponse(resultCount: 1, results: [makeData()])

        let models = mapper.transformResponseToModel(response: response)
        let music = try #require(models.first)

        #expect(music.previewUrl == URL(string: "https://audio.example.com/blank-space.m4a"))
        #expect(music.artworkUrl == URL(string: "https://artwork.example.com/blank-space/100x100bb.jpg"))
    }

    @Test("Falls back to nil URLs when links are not valid URLs")
    func fallsBackToNilURLsForInvalidLinks() throws {
        let response = MusicsResponse(
            resultCount: 1,
            results: [makeData(previewUrl: "", artworkUrl100: "")]
        )

        let models = mapper.transformResponseToModel(response: response)
        let music = try #require(models.first)

        #expect(music.previewUrl == nil)
        #expect(music.artworkUrl == nil)
    }
}
