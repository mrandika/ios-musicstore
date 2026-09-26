//
//  AudioPlayerManager.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import AVFoundation
import Observation

enum PlaybackStatus: Equatable {
    case idle       // nothing loaded
    case playing
    case paused
}

@MainActor
@Observable
class AudioPlayerManager {
    private var player: AVPlayer?
    private var endObserver: NSObjectProtocol?
    private var timeObserver: Any?
    
    private(set) var queue: [MusicModel] = []
    private(set) var currentIndex: Int?
    private(set) var status: PlaybackStatus = .idle
    
    private(set) var currentTime: Double = 0
    private(set) var duration: Double = 0
    
    var currentMusic: MusicModel? {
        guard let currentIndex, queue.indices.contains(currentIndex) else { return nil }
        return queue[currentIndex]
    }
    
    var isPlaying: Bool { status == .playing }
    var isPaused: Bool { status == .paused }
    
    func play(queue: [MusicModel], startAt index: Int) {
        self.queue = queue
        playItem(at: index)
    }
    
    func pause() {
        player?.pause()
        status = .paused
    }
    
    func resume() {
        player?.play()
        status = .playing
    }
    
    func playNext() {
        guard let currentIndex else { return }
        let nextIndex = currentIndex + 1
        guard queue.indices.contains(nextIndex) else {
            status = .idle
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
    
    func seek(to time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player?.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
        currentTime = time
    }
    
    private func playItem(at index: Int) {
        guard queue.indices.contains(index),
              let url = URL(string: queue[index].previewLink) else { return }
        
        cleanupObservers()
        
        currentIndex = index
        currentTime = 0
        duration = 0
        
        let asset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        status = .playing
        
        Task {
            await loadDuration(from: url)
        }
        
        timeObserver = player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.25, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            self?.currentTime = time.seconds
        }
        
        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            self?.playNext()
        }
    }
    
    private func loadDuration(from url: URL) async {
        let asset = AVURLAsset(url: url)
        guard let loaded = try? await asset.load(.duration) else { return }
        self.duration = loaded.seconds
    }
    
    private func cleanupObservers() {
        if let endObserver {
            NotificationCenter.default.removeObserver(endObserver)
        }
        if let timeObserver {
            player?.removeTimeObserver(timeObserver)
        }
    }
}
