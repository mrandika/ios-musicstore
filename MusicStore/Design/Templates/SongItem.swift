//
//  SongItem.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct SongItem: View {
    var artwork: URL?
    var name: String
    var collection: String
    var artists: String
    var isExplicit: Bool
    
    init(
        artwork: URL? = nil,
        name: String,
        collection: String,
        artists: String,
        isExplicit: Bool
    ) {
        self.artwork = artwork
        self.name = name
        self.collection = collection
        self.artists = artists
        self.isExplicit = isExplicit
    }
    
    var body: some View {
        HStack(
            alignment: .top,
            spacing: Spacing.large.points
        ) {
            RemoteImageView(artwork, width: 64, heigt: 64)
            
            VStack(
                alignment: .leading,
                spacing: Spacing.xSmall.points
            ) {
                HStack {
                    SongTitleView(name: name, isExplicit: isExplicit)
                    
                    Spacer()
                    
                    AnimatedSystemImage("music.quarternote.3", isActive: true)
                        .frame(width: 18)
                }
                
                SongArtistNameView(name: artists)
                
                SongCollectionView(name: collection)
                    .padding(.top, Spacing.xSmall.points)
            }
        }
    }
}

#Preview {
    List {
        SongItem(
            artwork: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/bb/47/a3/bb47a36e-57b8-9260-f9a4-d09851145c45/00602557100556.rgb.jpg/100x100bb.jpg"),
            name: "City of Stars",
            collection: "La La Land (Original Motion Picture Soundtrack)",
            artists: "Ryan Gosling & Emma Stone",
            isExplicit: false
        )
    }.listStyle(.plain)
}
