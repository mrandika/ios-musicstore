//
//  ExpandedPlayerView.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct ExpandedPlayerView: View {
    @Environment(AudioPlayerManager.self) var playerManager
    
    var currentMusic: MusicModel? {
        guard let currentMusic = playerManager.currentMusic else {
            return nil
        }
        
        return currentMusic
    }
    
    var body: some View {
        VStack(spacing: Spacing.large.points) {
            RemoteImageView(
                currentMusic?.artworkUrl,
                width: 96,
                height: 96
            )
            
            VStack(spacing: Spacing.small.points) {
                SongTitleView(
                    name: currentMusic?.trackName ?? "",
                    isExplicit: currentMusic?.isExplicit ?? false
                )
                
                SongArtistNameView(name: currentMusic?.artistName ?? "")
            }
            
            SongScrubberView(
                currentTime: playerManager.currentTime,
                duration: playerManager.duration,
                onSeek: { newTime in
                    playerManager.seek(to: newTime)
                }
            )
            
            HStack(spacing: Spacing.xxxLarge.points) {
                Button(action: {
                    playerManager.playPrevious()
                }, label: {
                    ImageButtonLabel(systemName: "backward.fill")
                        .frame(height: 24)
                })
                
                Button(action: {
                    playerManager.togglePlayPause()
                }, label: {
                    ImageButtonLabel(
                        systemName: playerManager.isPlaying ? "pause.fill" : "play.fill"
                    ).frame(height: 24)
                })
                
                Button(action: {
                    playerManager.playNext()
                }, label: {
                    ImageButtonLabel(systemName: "forward.fill")
                        .frame(height: 24)
                })
            }
        }.padding()
    }
}

#Preview {
    ExpandedPlayerView()
        .environment(AudioPlayerManager())
}
