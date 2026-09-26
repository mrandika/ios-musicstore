//
//  AudioPlayerManager.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import AVFoundation
import Observation

@Observable
class AudioPlayerManager {
    private var player: AVPlayer?
    private var endObserver: NSObjectProtocol?
    
    private(set) var queue: [String] = []
    private(set) var currentIndex: Int?
    private(set) var isPlaying = false
    
    var currentURL: String? {
        guard let currentIndex, queue.indices.contains(currentIndex) else { return nil }
        return queue[currentIndex]
    }
    
    // Call this once when the user taps a song in a list of results
    func play(queue: [String], startAt index: Int) {
        self.queue = queue
        playItem(at: index)
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func resume() {
        player?.play()
        isPlaying = true
    }
    
    func playNext() {
        guard let currentIndex else { return }
        let nextIndex = currentIndex + 1
        guard queue.indices.contains(nextIndex) else {
            isPlaying = false
            return
        }
        playItem(at: nextIndex)
    }
    
    func playPrevious() {
        guard let currentIndex else { return }
        let prevIndex = currentIndex - 1
        guard queue.indices.contains(prevIndex) else { return }
        playItem(at: prevIndex)
    }
    
    private func playItem(at index: Int) {
        guard queue.indices.contains(index),
              let url = URL(string: queue[index]) else { return }
        
        cleanupObserver()
        
        currentIndex = index
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        isPlaying = true
        
        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            self?.playNext() // auto-advance
        }
    }
    
    private func cleanupObserver() {
        if let endObserver {
            NotificationCenter.default.removeObserver(endObserver)
        }
    }
}
