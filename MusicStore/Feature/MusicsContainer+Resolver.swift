//
//  MusicsContainer+Resolver.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

@MainActor
public final class MusicsContainer {
    public static func registerDepedencies() {
        registerMusics()
    }
}

@MainActor
public class MusicsResolver {
    internal static let musicsRepository = try! DependencyContainer.shared.resolve(MusicsRepositoryProtocol.self)
    public static let musicsInteractor = try! DependencyContainer.shared.resolve(MusicsInteractorProtocol.self)
}

extension MusicsContainer {
    private static func registerMusics() {
        DependencyContainer.shared.register(
            MusicsRepositoryProtocol.self,
            MusicsRepository(
                client: APIClient.shared
            )
        )
        
        DependencyContainer.shared.register(
            MusicsInteractorProtocol.self,
            MusicsInteractor(
                repository: MusicsResolver.musicsRepository
            )
        )
    }
}
