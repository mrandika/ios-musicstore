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
                    URLQueryItem(name: "term", value: term),
                    URLQueryItem(name: "entity", value: "song")
                ]
            )
        }
    }
}
