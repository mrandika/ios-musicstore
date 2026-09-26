//
//  SongCollectionView.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct SongCollectionView: View {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    var body: some View {
        StyledText(
            name, weight: .regular, size: .xxSmall
        ).opacity(0.5)
            .lineLimit(1)
    }
}

#Preview {
    SongCollectionView(
        name: "La La Land (Original Motion Picture Soundtrack)"
    )
}
