//
//  MusicListView.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct MusicListView: View {
    @Environment(AudioPlayerManager.self) var playerManager
    
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
                    musicId: music.id
                )
            }, label: {
                SongItem(
                    artwork: music.artworkUrl,
                    name: music.trackName,
                    collection: music.collectionName,
                    artists: music.artistName,
                    isExplicit: music.isExplicit,
                    isPlayed: playerManager.currentMusic?.id == music.id && playerManager.isPlaying
                )
            }).buttonStyle(.plain)
        }.stateAware(
            isLoading: presenter.isLoading,
            error: presenter.error,
            isEmpty: presenter.musics.isEmpty,
            recoveryAction: {
                Task {
                    await presenter.debounceAndFetch(with: query)
                }
            }
        ).searchable(
            text: $query,
            placement: .toolbar,
            prompt: "Artists or Song name"
        ).task(
            id: query
        ) {
            if query.isEmpty { return }
            
            await presenter.debounceAndFetch(with: query)
        }.navigationTitle(
            "Library"
        )
    }
    
    func toggleMusic(musicId: Int) {
        if playerManager.currentMusic?.id == musicId {
            if playerManager.isPlaying {
                playerManager.pause()
            } else {
                playerManager.resume()
            }
        } else {
            guard let startIndex = presenter.musics.firstIndex(where: { $0.id == musicId }) else {
                return
            }
            playerManager.play(queue: presenter.musics, startAt: startIndex)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        init() {
            MusicsContainer.registerDependencies()
        }
        
        var body: some View {
            MusicListView()
        }
    }
    
    return PreviewWrapper()
        .environment(AudioPlayerManager())
}
