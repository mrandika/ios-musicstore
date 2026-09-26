//
//  MusicsPresenterFactory.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

struct MusicsPresenterFactory: MusicsPresenterFactoryProtocol {
    private let injection: Injection

    init(injection: Injection = Injection()) {
        self.injection = injection
    }

    func makeMusicListPresenter() -> MusicListPresenter {
        MusicListPresenter(interactor: injection.provideMusicInteractor())
    }
}
