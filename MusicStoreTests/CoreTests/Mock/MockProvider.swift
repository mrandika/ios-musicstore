//
//  MockProvider.swift
//  MusicStoreTests
//
//  Created by Andika on 26/09/26.
//

import Foundation
@testable import MusicStore

struct MockProvider: APIServiceProvider {
    var endpoint: String
    var service: APIService
}
