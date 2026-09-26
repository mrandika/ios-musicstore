//
//  ContentView.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(AudioPlayerManager.self) var playerManager
    @State private var showExpandedPlayer: Bool = false
    
    var body: some View {
        TabView {
            Tab("Library", systemImage: "books.vertical.fill") {
                NavigationStack {
                    MusicListView()
                }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewBottomAccessory {
            MiniPlayerView()
                .contentShape(Rectangle())
                .onTapGesture {
                    if playerManager.status == .idle { return }
                    
                    showExpandedPlayer.toggle()
                }
        }.sheet(isPresented: $showExpandedPlayer) {
            ExpandedPlayerView()
                .presentationDetents([.height(320)])
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        init() {
            MusicsContainer.registerDependencies()
        }
        
        var body: some View {
            ContentView()
        }
    }
    
    return PreviewWrapper()
        .environment(AudioPlayerManager())
}
