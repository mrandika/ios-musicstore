//
//  MockResponse.swift
//  MusicStoreTests
//
//  Created by Andika on 26/09/26.
//

import Foundation

struct MockResponse: Decodable, Sendable, Equatable {
    let id: String
    let name: String
}
