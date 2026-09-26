//
//  MockURLSession.swift
//  MusicStoreTests
//
//  Created by Andika on 26/09/26.
//

import Foundation

final class MockURLSession {
    func makeMockSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        return URLSession(configuration: config)
    }
}
