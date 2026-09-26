//
//  MusicListPresenter.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

@MainActor
public protocol MusicListPresenterProtocol: Sendable {
    func searchMusic(with term: String) async
}

@Observable
public final class MusicListPresenter: MusicListPresenterProtocol {
    let lists: [Int] = [1,2,3]
    
    let interactor: MusicsInteractorProtocol
    
    public var isLoading: Bool = false
    public var error: Error? = nil
    public var musics: [MusicModel] = []
    
    public init(
        interactor: MusicsInteractorProtocol
    ) {
        self.interactor = interactor
    }
    
    public func searchMusic(with term: String) async {
        self.isLoading = true
        self.error = nil
        
        defer {
            self.isLoading = false
        }
        
        do {
            self.musics = try await interactor.searchMusic(with: term)
        } catch {
            self.error = error
        }
    }
}
