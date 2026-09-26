//
//  MusicListAPIService.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

enum MusicListAPIService: APIServiceProvider {
    case search(
        term: String
    )
    
    var endpoint: String {
        switch self {
        case .search: "/search"
        }
    }
    
    var service: APIService {
        switch self {
        case .search(let term):
            .init(
                endpoint,
                method: .get,
                queryItems: [
                    "term": term,
                    "entity": "music"
                ]
            )
        }
    }
}
