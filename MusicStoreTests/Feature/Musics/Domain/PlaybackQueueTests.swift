//
//  PlaybackQueueTests.swift
//  MusicStoreTests
//
//  Created by Andika on 26/09/26.
//

import Testing
@testable import MusicStore

@Suite("PlaybackQueue")
struct PlaybackQueueTests {
    private func tracks(_ ids: Int...) -> [MusicModel] {
        ids.map {
            MusicModel(
                id: $0, isExplicit: false,
                artistName: "Artist \($0)", collectionName: "Collection",
                trackName: "Track \($0)",
                previewLink: "https://audio.example.com/\($0).m4a",
                artworkLink: "https://artwork.example.com/\($0).jpg"
            )
        }
    }

    @Test("Loads at the requested index")
    func loadAtIndex() {
        var queue = PlaybackQueue()
        let current = queue.load(tracks(1, 2, 3), startAt: 1)
        #expect(current?.id == 2)
    }

    @Test("Advance stops on the last track instead of clearing it")
    func advanceStopsAtEnd() {
        var queue = PlaybackQueue()
        queue.load(tracks(1, 2), startAt: 1)
        #expect(queue.advance() == nil)
        #expect(queue.current?.id == 2)
    }

    @Test("Rewind stops on the first track")
    func rewindStopsAtStart() {
        var queue = PlaybackQueue()
        queue.load(tracks(1, 2), startAt: 0)
        #expect(queue.rewind() == nil)
        #expect(queue.current?.id == 1)
    }
}
