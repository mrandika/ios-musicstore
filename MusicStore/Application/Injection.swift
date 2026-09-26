//
//  Injection.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

@MainActor
final class Injection {
    private let interactor: MusicsInteractorProtocol

    init(container: DependencyContainer = .shared) {
        MusicsContainer.registerDependencies(in: container)
        
        guard let interactor = try? container.resolve(MusicsInteractorProtocol.self) else {
            preconditionFailure("MusicsInteractorProtocol is not registered.")
        }
        
        self.interactor = interactor
    }

    func provideMusicInteractor() -> MusicsInteractorProtocol { interactor }
}
