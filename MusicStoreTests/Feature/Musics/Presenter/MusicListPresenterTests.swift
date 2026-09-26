//
//  MusicListPresenterTests.swift
//  MusicStoreTests
//
//  Created by Andika on 26/09/26.
//

import Testing
import Foundation
@testable import MusicStore

private let searchResponseJSON = """
{
    "resultCount": 1,
    "results": [
        {
            "trackId": 1440857781,
            "trackExplicitness": "notExplicit",
            "artistName": "Taylor Swift",
            "collectionName": "1989",
            "trackName": "Blank Space",
            "previewUrl": "https://audio.example.com/blank-space.m4a",
            "artworkUrl100": "https://artwork.example.com/blank-space/100x100bb.jpg"
        }
    ]
}
"""

@Suite("MusicListPresenter", .serialized)
@MainActor
struct MusicListPresenterTests {
    private func makePresenter() -> MusicListPresenter {
        let client = APIClient(session: MockURLSession().makeMockSession())
        let repository = MusicsRepository(client: client)
        let interactor = MusicsInteractor(repository: repository)

        return MusicListPresenter(interactor: interactor)
    }

    private func stubSuccess(delay: TimeInterval = 0) {
        MockURLProtocol.requestHandler = { request in
            if delay > 0 {
                Thread.sleep(forTimeInterval: delay)
            }

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            return (response, Data(searchResponseJSON.utf8))
        }
    }

    private func stubFailure(statusCode: Int, body: String = "{}") {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!

            return (response, Data(body.utf8))
        }
    }

    @Test("Loads and maps musics on a successful search")
    func searchMusicSuccess() async throws {
        stubSuccess()
        let presenter = makePresenter()

        await presenter.searchMusic(with: "taylor swift")

        #expect(presenter.musics.count == 1)
        let music = try #require(presenter.musics.first)
        #expect(music.id == 1440857781)
        #expect(music.trackName == "Blank Space")
        #expect(music.artistName == "Taylor Swift")
        #expect(music.collectionName == "1989")
        #expect(music.isExplicit == false)
        #expect(music.previewLink == "https://audio.example.com/blank-space.m4a")
        #expect(music.artworkLink == "https://artwork.example.com/blank-space/100x100bb.jpg")
        #expect(presenter.error == nil)
        #expect(presenter.isLoading == false)
    }

    @Test("Sends the search term and song entity as query items")
    func searchMusicBuildsQuery() async throws {
        nonisolated(unsafe) var capturedURL: URL?

        MockURLProtocol.requestHandler = { request in
            capturedURL = request.url

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            return (response, Data(searchResponseJSON.utf8))
        }

        let presenter = makePresenter()
        await presenter.searchMusic(with: "blank space")

        let url = try #require(capturedURL)
        #expect(url.path == "/search")

        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = try #require(components.queryItems)
        #expect(queryItems.contains(URLQueryItem(name: "term", value: "blank space")))
        #expect(queryItems.contains(URLQueryItem(name: "entity", value: "song")))
    }

    @Test("Stores an HTTP error when the request fails", arguments: [400, 401, 404, 500])
    func searchMusicHTTPError(statusCode: Int) async throws {
        stubFailure(statusCode: statusCode)
        let presenter = makePresenter()

        await presenter.searchMusic(with: "taylor swift")

        let error = try #require(presenter.error as? APIError)
        guard case let .httpError(receivedStatusCode, _) = error else {
            Issue.record("Expected APIError.httpError, got \(error)")
            return
        }

        #expect(receivedStatusCode == statusCode)
        #expect(presenter.musics.isEmpty)
        #expect(presenter.isLoading == false)
    }

    @Test("Stores a decoding error when the payload doesn't match")
    func searchMusicDecodingError() async throws {
        stubFailure(statusCode: 200, body: #"{"unexpected":"shape"}"#)
        let presenter = makePresenter()

        await presenter.searchMusic(with: "taylor swift")

        let error = try #require(presenter.error as? APIError)
        guard case let .decodingError(underlying) = error else {
            Issue.record("Expected APIError.decodingError, got \(error)")
            return
        }

        #expect(underlying is DecodingError)
        #expect(presenter.musics.isEmpty)
        #expect(presenter.isLoading == false)
    }

    @Test("Stores a transport error when the request can't reach the network")
    func searchMusicTransportError() async throws {
        MockURLProtocol.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }

        let presenter = makePresenter()
        await presenter.searchMusic(with: "taylor swift")

        let error = try #require(presenter.error as? APIError)
        guard case let .transportError(underlying) = error else {
            Issue.record("Expected APIError.transportError, got \(error)")
            return
        }

        #expect((underlying as? URLError)?.code == .notConnectedToInternet)
        #expect(presenter.musics.isEmpty)
    }

    @Test("Clears a previous error on a successful retry")
    func searchMusicClearsPreviousError() async throws {
        stubFailure(statusCode: 500)
        let presenter = makePresenter()

        await presenter.searchMusic(with: "taylor swift")
        #expect(presenter.error != nil)

        stubSuccess()
        await presenter.searchMusic(with: "taylor swift")

        #expect(presenter.error == nil)
        #expect(presenter.musics.count == 1)
    }

    @Test("Toggles isLoading around an in-flight request")
    func searchMusicTogglesLoading() async throws {
        stubSuccess(delay: 0.3)
        let presenter = makePresenter()

        #expect(presenter.isLoading == false)

        let task = Task { await presenter.searchMusic(with: "taylor swift") }
        try await Task.sleep(for: .milliseconds(50))
        #expect(presenter.isLoading == true)

        await task.value
        #expect(presenter.isLoading == false)
    }

    @Test("Debounces before performing the search")
    func debounceAndFetchWaitsBeforeSearching() async throws {
        stubSuccess()
        let presenter = makePresenter()

        let task = Task { await presenter.debounceAndFetch(with: "taylor swift") }
        try await Task.sleep(for: .milliseconds(100))
        #expect(presenter.musics.isEmpty)

        await task.value
        #expect(presenter.musics.count == 1)
    }

    @Test("Ignores cancellation while debouncing")
    func debounceAndFetchIgnoresCancellation() async throws {
        stubSuccess()
        let presenter = makePresenter()

        let task = Task { await presenter.debounceAndFetch(with: "taylor swift") }
        try await Task.sleep(for: .milliseconds(100))
        task.cancel()
        await task.value

        #expect(presenter.musics.isEmpty)
        #expect(presenter.error == nil)
    }
    
    @Test("Cancelling an in-flight search does not surface an error")
    func cancelledSearchStaysSilent() async throws {
        MockURLProtocol.requestHandler = { request in
            Thread.sleep(forTimeInterval: 0.5)
            let response = HTTPURLResponse(
                url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil
            )!
            return (response, Data(searchResponseJSON.utf8))
        }

        let presenter = makePresenter()
        let task = Task { await presenter.searchMusic(with: "taylor swift") }
        try await Task.sleep(for: .milliseconds(50))
        task.cancel()
        await task.value

        #expect(presenter.error == nil)
        #expect(presenter.musics.isEmpty)
        #expect(presenter.isLoading == false)
    }
}
