//
//  MusicsPresenterFactoryProtocol.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

@MainActor
public protocol MusicsPresenterFactoryProtocol: Sendable {
    func makeMusicListPresenter() -> MusicListPresenter
}
