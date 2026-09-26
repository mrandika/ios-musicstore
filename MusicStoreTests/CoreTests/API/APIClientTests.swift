//
//  APIClientTests.swift
//  MusicStoreTests
//
//  Created by Andika on 26/09/26.
//

import Testing
import Foundation
@testable import MusicStore

@Suite("APIClient", .serialized)
@MainActor
struct APIClientTests {
    @Test("Successfully decodes a valid JSON response")
    func fetchSuccess() async throws {
        MockURLProtocol.requestHandler = { request in
            let json = #"{"id":"1","name":"Example"}"#.data(using: .utf8)!
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, json)
        }
        
        let client = APIClient(
            session: MockURLSession().makeMockSession()
        )
        
        let provider = MockProvider(
            endpoint: "/search/1",
            service: APIService("/search/1", method: .get)
        )
        
        let user: MockResponse = try await client.fetch(baseUrl: "https://api.example.com", provider)
        
        #expect(user == MockResponse(id: "1", name: "Example"))
    }
    
    @Test("Builds correct URL with path and query items")
    func fetchBuildsCorrectURL() async throws {
        nonisolated(unsafe) var capturedURL: URL?
        
        MockURLProtocol.requestHandler = { request in
            capturedURL = request.url
            let json = #"{"id":"1","name":"Example"}"#.data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, json)
        }
        
        let client = APIClient(
            session: MockURLSession().makeMockSession()
        )
        
        let provider = MockProvider(
            endpoint: "/search",
            service: APIService("/search", method: .get, queryItems: [URLQueryItem(name: "limit", value: "100")])
        )
        
        let _: MockResponse = try await client.fetch(
            baseUrl: "https://api.example.com",
            provider
        )
        
        let url = try #require(capturedURL)
        #expect(url.path == "/search")
        
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = try #require(components.queryItems)
        #expect(queryItems.contains(URLQueryItem(name: "limit", value: "100")))
    }
    
    @Test("Sends the correct HTTP method")
    func fetchSendsCorrectMethod() async throws {
        nonisolated(unsafe) var capturedMethod: String?
        
        MockURLProtocol.requestHandler = { request in
            capturedMethod = request.httpMethod
            let json = #"{"id":"1","name":"Example"}"#.data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, json)
        }
        
        let client = APIClient(
            session: MockURLSession().makeMockSession()
        )
        
        let provider = MockProvider(endpoint: "/search", service: APIService("/search", method: .get))
        
        let _: MockResponse = try await client.fetch(
            baseUrl: "https://api.example.com",
            provider
        )
        
        #expect(capturedMethod == "GET")
    }
    
    @Test("Throws invalidBaseURL for a malformed base URL", arguments: [
        "not a url",
        "://missing-scheme.com",
        "",
        "   "
    ])
    func fetchThrowsInvalidBaseURL(badBaseUrl: String) async throws {
        let client = APIClient(session: MockURLSession().makeMockSession())
        let provider = MockProvider(endpoint: "/search", service: APIService("/search", method: .get))

        do {
            let _: MockResponse = try await client.fetch(baseUrl: badBaseUrl, provider)
            Issue.record("Expected fetch to throw .invalidBaseURL, but it succeeded")
        } catch APIError.invalidBaseURL {
            // expected
        } catch {
            Issue.record("Expected APIError.invalidBaseURL, got \(error)")
        }
    }
    
    @Test("Throws httpError for non-2xx status codes", arguments: [400, 401, 404, 500])
    func fetchThrowsHTTPError(statusCode: Int) async throws {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        
        let client = APIClient(
            session: MockURLSession().makeMockSession()
        )
        
        let provider = MockProvider(endpoint: "/search", service: APIService("/search", method: .get))
        
        do {
            let _: MockResponse = try await client.fetch(
                baseUrl: "https://api.example.com",
                provider
            )
            
            Issue.record("Expected fetch to throw, but it succeeded")
        } catch let APIError.httpError(code, _) {
            #expect(code == statusCode)
        } catch {
            Issue.record("Expected APIError.httpError, got \(error)")
        }
    }
    
    @Test("Throws decodingError when the response body doesn't match the model")
    func fetchThrowsDecodingError() async throws {
        MockURLProtocol.requestHandler = { request in
            let malformed = #"{"unexpected":"shape"}"#.data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, malformed)
        }
        
        let client = APIClient(
            session: MockURLSession().makeMockSession()
        )
        
        let provider = MockProvider(endpoint: "/search", service: APIService("/search", method: .get))
        
        do {
            let _: MockResponse = try await client.fetch(
                baseUrl: "https://api.example.com",
                provider
            )
            
            Issue.record("Expected fetch to throw a decoding error")
        } catch let APIError.decodingError(underlying) {
            #expect(underlying is DecodingError)
        } catch {
            Issue.record("Expected APIError.decodingError, got \(error)")
        }
    }
    
    @Test("Throws transportError when the underlying request fails")
    func fetchThrowsTransportError() async throws {
        MockURLProtocol.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }
        
        let client = APIClient(
            session: MockURLSession().makeMockSession()
        )
        
        let provider = MockProvider(endpoint: "/search", service: APIService("/search", method: .get))
        
        do {
            let _: MockResponse = try await client.fetch(
                baseUrl: "https://api.example.com",
                provider
            )
            
            Issue.record("Expected fetch to throw a transport error")
        } catch let APIError.transportError(underlying) {
            #expect((underlying as? URLError)?.code == .notConnectedToInternet)
        } catch {
            Issue.record("Expected APIError.transportError, got \(error)")
        }
    }
    
    @Test("Decodes an array response correctly")
    func fetchDecodesArray() async throws {
        MockURLProtocol.requestHandler = { request in
            let json = #"[{"id":"1","name":"Example"},{"id":"2","name":"Example"}]"#.data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, json)
        }
        
        let client = APIClient(
            session: MockURLSession().makeMockSession()
        )
        
        let provider = MockProvider(endpoint: "/users", service: APIService("/users", method: .get))
        
        let users: [MockResponse] = try await client.fetch(
            baseUrl: "https://api.example.com",
            provider
        )
        
        #expect(users.count == 2)
        #expect(users.first?.id == "1")
    }
}
