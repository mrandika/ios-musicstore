//
//  MusicStoreApp.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI
import AVFoundation

@main
struct MusicStoreApp: App {
    init() {
        configureAudioSession()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default)
        } catch {
            debugPrint("Failed to set category: \(error)")
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try session.setActive(true)
            } catch {
                debugPrint("Failed to activate: \(error)")
            }
        }
    }
}
