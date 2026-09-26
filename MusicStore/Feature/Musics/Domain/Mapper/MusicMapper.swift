//
//  MusicMapper.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

struct MusicMapper: Mapper {
    typealias Response = MusicsResponse
    typealias Model = [MusicModel]

    func transformResponseToModel(
        response: Response
    ) -> Model {
        response.results.map {
            .init(
                id: $0.trackId,
                artistName: $0.artistName,
                collectionName: $0.collectionName,
                trackName: $0.trackName,
                previewLink: $0.previewURL,
                artworkLink: $0.artworkUrl100
            )
        }
    }
}
