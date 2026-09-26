//
//  ContentView.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            MusicListView()
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        init() {
            MusicsContainer.registerDepedencies()
        }
        
        var body: some View {
            ContentView()
        }
    }
    
    return PreviewWrapper()
}
