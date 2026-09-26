//
//  MusicListView.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct MusicListView: View {
    @State private var presenter: MusicListPresenter = .init()
    @State private var query: String = ""
    
    var body: some View {
        List(presenter.lists, id: \.self) { list in
            Text("\(list)")
        }.searchable(
            text: $query
        ).navigationTitle(
            "Home"
        )
    }
}

#Preview {
    MusicListView()
}
