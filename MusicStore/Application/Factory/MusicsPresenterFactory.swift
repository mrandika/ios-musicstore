//
//  MusicsPresenterFactory.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

struct MusicsPresenterFactory: MusicsPresenterFactoryProtocol {
    private let injection = Injection()
    
    func makeMusicListPresenter() -> MusicListPresenter {
        MusicListPresenter(interactor: injection.provideMusicInteractor())
    }
}
