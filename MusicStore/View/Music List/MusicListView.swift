//
//  MusicListView.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct MusicListView: View {
    @State private var playerManager = AudioPlayerManager()
    
    @State private var presenter: MusicListPresenter
    @State private var query: String
    
    @State private var currentPlayId: Int?
    
    init(
        query: String = ""
    ) {
        self._presenter = State(
            initialValue: MusicsPresenterFactory().makeMusicListPresenter()
        )
        
        self.query = query
    }
    
    var body: some View {
        List(presenter.musics, id: \.id) { music in
            Button(action: {
                toggleMusic(
                    musicId: music.id,
                    previewLink: music.previewLink
                )
            }, label: {
                SongItem(
                    artwork: music.artworkUrl,
                    name: music.trackName,
                    collection: music.collectionName,
                    artists: music.artistName,
                    isExplicit: false,
                    isPlayed: playerManager.currentURL == music.previewLink && playerManager.isPlaying
                )
            }).buttonStyle(.plain)
        }.stateAware(
            isLoading: presenter.isLoading,
            error: presenter.error,
            isEmpty: presenter.musics.isEmpty,
            recoveryAction: {
                Task {
                    await debounceAndFetch(with: query)
                }
            }
        ).searchable(
            text: $query
        ).task(
            id: query
        ) {
            if query.isEmpty { return }
            
            await debounceAndFetch(with: query)
        }.navigationTitle(
            "Library"
        )
    }
    
    func debounceAndFetch(with query: String) async {
        do {
            try await Task.sleep(for: .milliseconds(500))
            await presenter.searchMusic(with: query)
        } catch {
            // Task was cancelled because query changed again is expected, ignore
        }
    }
    
    func toggleMusic(musicId: Int, previewLink: String) {
        if currentPlayId == musicId {
            if playerManager.isPlaying {
                playerManager.pause()
            } else {
                playerManager.resume()
            }
        } else {
            let queue = presenter.musics.map {
                MusicQueueModel(id: $0.id, previewUrl: $0.previewLink)
            }
            
            guard let startIndex = presenter.musics.firstIndex(where: { $0.id == musicId }) else {
                return
            }
            
            playerManager.play(
                queue: queue.map { $0.previewUrl },
                startAt: startIndex
            )
            
            currentPlayId = musicId
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        init() {
            MusicsContainer.registerDepedencies()
        }
        
        var body: some View {
            MusicListView()
        }
    }
    
    return PreviewWrapper()
}
