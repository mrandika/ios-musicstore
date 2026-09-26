//
//  MiniPlayerView.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct MiniPlayerView: View {
    @Environment(AudioPlayerManager.self) var playerManager
    
    var body: some View {
        if let currentMusic = playerManager.currentMusic {
            HStack {
                RemoteImageView(
                    currentMusic.artworkUrl,
                    width: 32,
                    height: 32
                )
                
                VStack(
                    alignment: .leading, spacing: Spacing.xSmall.points
                ) {
                    // Don't show explicit badge on MiniPlayer
                    SongTitleView(
                        name: currentMusic.trackName,
                        isExplicit: false
                    ).lineLimit(1)
                    
                    SongArtistNameView(
                        name: currentMusic.artistName
                    )
                }
                
                Spacer()
                
                HStack(spacing: Spacing.large.points) {
                    Button(action: {
                        playerManager.isPaused ? playerManager
                            .resume() : playerManager.pause()
                    }, label: {
                        ImageButtonLabel(
                            systemName: playerManager.isPlaying ? "pause.fill" : "play.fill"
                        ).frame(height: 18)
                    })
                    
                    Button(action: {
                        playerManager.playNext()
                    }, label: {
                        ImageButtonLabel(systemName: "forward.fill")
                            .frame(height: 18)
                    })
                }
            }.padding()
        } else {
            StyledText("Not Playing")
        }
    }
}

#Preview {
    MiniPlayerView()
}
