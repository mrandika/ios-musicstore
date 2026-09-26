//
//  PlaybackQueue.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

struct PlaybackQueue: Sendable {
    private(set) var items: [MusicModel] = []
    private(set) var index: Int?

    var current: MusicModel? {
        guard let index, items.indices.contains(index) else { return nil }
        return items[index]
    }

    @discardableResult
    mutating func load(_ items: [MusicModel], startAt index: Int) -> MusicModel? {
        self.items = items
        guard items.indices.contains(index) else {
            self.index = nil
            return nil
        }
        self.index = index
        return items[index]
    }

    @discardableResult
    mutating func advance() -> MusicModel? {
        guard let index else { return nil }
        let next = index + 1
        guard items.indices.contains(next) else { return nil }   // stays on last track
        self.index = next
        return items[next]
    }

    @discardableResult
    mutating func rewind() -> MusicModel? {
        guard let index, index > 0, items.indices.contains(index - 1) else { return nil }
        self.index = index - 1
        return items[index - 1]
    }
}
