//
//  MusicListResponse.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

struct MusicsResponse: Decodable, Sendable {
    let resultCount: Int
    let results: [MusicDataResponse]
}

struct MusicDataResponse: Decodable, Sendable {
    let trackId: Int
    let trackExplicitness: String
    let artistName: String
    let collectionName: String
    let trackName: String
    let previewUrl: String
    let artworkUrl100: String
}
