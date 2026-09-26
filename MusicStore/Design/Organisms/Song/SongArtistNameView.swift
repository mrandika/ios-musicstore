//
//  SongArtistName.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct SongArtistNameView: View {
    var name: String
    
    var body: some View {
        StyledText(name, weight: .regular, size: .small)
            .opacity(0.8)
    }
}

#Preview {
    SongArtistNameView(name: "Ryan Gosling")
}
