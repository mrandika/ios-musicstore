//
//  MusicListView.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct MusicListView: View {
    @State private var presenter: MusicListPresenter
    @State private var query: String
    
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
            SongItem(
                artwork: music.artworkUrl,
                name: music.trackName,
                collection: music.collectionName,
                artists: music.artistName,
                isExplicit: false
            )
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
            "Home"
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
