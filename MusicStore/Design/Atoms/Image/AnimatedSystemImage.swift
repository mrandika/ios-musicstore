//
//  AnimatedSystemImage.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct AnimatedSystemImage: View {
    var name: String
    var isActive: Bool
    
    init(
        _ name: String,
        isActive: Bool
    ) {
        self.name = name
        self.isActive = isActive
    }
    
    var body: some View {
        Image(systemName: name)
            .resizable()
            .scaledToFit()
            .symbolEffect(
                .breathe,
                options: .repeating,
                isActive: isActive
            )
    }
}

#Preview {
    AnimatedSystemImage("music.quarternote.3", isActive: true)
        .frame(width: 32)
}
