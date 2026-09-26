//
//  MusicsInteractor.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

public protocol MusicsInteractorProtocol: Sendable {
    func searchMusic(with term: String) async throws -> [MusicModel]
}

public final class MusicsInteractor: MusicsInteractorProtocol {
    private let repository: MusicsRepositoryProtocol
    
    public required init(repository: MusicsRepositoryProtocol) {
        self.repository = repository
    }
    
    public func searchMusic(with term: String) async throws -> [MusicModel] {
        try await repository.searchMusic(with: term)
    }
}
