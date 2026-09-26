//
//  MusicModel.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

public struct MusicModel: Identifiable, Sendable {
    public let id: Int
    public let artistName: String
    public let collectionName: String
    public let trackName: String
    public let previewLink: String
    public let artworkLink: String
    
    public var previewUrl: URL? {
        URL(string: previewLink)
    }
    
    public var artworkUrl: URL? {
        URL(string: artworkLink)
    }
}
