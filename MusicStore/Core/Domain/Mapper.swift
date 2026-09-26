//
//  Mapper.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

/// A protocol that defines a two-step mapping process between different data representations.
public protocol Mapper {
    associatedtype Response: Sendable
    associatedtype Model: Sendable

    /// Function to transform Data Response into Data Model.
    func transformResponseToModel(response: Response) -> Model
}
