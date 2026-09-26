//
//  Injection.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

@MainActor
final class Injection: NSObject {
    override init() {
        super.init()
        setupDependencies()
    }
    
    public func provideMusicInteractor() -> MusicsInteractorProtocol {
        return MusicsResolver.musicsInteractor
    }
}

extension Injection {
    private func setupDependencies() {
        MusicsContainer.registerDepedencies()
    }
}
