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
            Text(music.trackName)
        }.searchable(
            text: $query
        ).navigationTitle(
            "Home"
        )
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
