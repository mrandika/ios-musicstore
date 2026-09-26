//
//  AudioPlayerManager.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import AVFoundation

@Observable
class AudioPlayerManager {
    private var player: AVPlayer?
    private(set) var isPlaying = false
    private var endObserver: NSObjectProtocol?
    
    func play(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        cleanupObserver()
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        isPlaying = true
        
        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            self?.isPlaying = false
        }
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func resume() {
        player?.play()
        isPlaying = true
    }
    
    private func cleanupObserver() {
        if let endObserver {
            NotificationCenter.default.removeObserver(endObserver)
        }
    }
}
