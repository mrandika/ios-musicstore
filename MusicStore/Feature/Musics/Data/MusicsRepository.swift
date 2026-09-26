//
//  MusicListRepository.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

public protocol MusicsRepositoryProtocol: Sendable {
    func searchMusic(with term: String) async throws -> [MusicModel]
}

public final class MusicsRepository: MusicsRepositoryProtocol {
    private let client: APIClientProtocol
    
    public required init(client: APIClientProtocol) {
        self.client = client
    }
    
    public func searchMusic(with term: String) async throws -> [MusicModel] {
        let response: MusicsResponse = try await client.fetch(
            baseUrl: APIConfiguration().baseUrl,
            MusicListAPIService.search(term: term)
        )
        
        return MusicMapper()
            .transformResponseToModel(response: response)
    }
}
