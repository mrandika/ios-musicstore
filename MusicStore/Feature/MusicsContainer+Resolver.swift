//
//  MusicsContainer+Resolver.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

@MainActor
public enum MusicsContainer {
    public static func registerDependencies(in container: DependencyContainer = .shared) {
        let repository = MusicsRepository(client: APIClient.shared)
        container.register(MusicsRepositoryProtocol.self, repository)
        container.register(MusicsInteractorProtocol.self, MusicsInteractor(repository: repository))
    }
}
