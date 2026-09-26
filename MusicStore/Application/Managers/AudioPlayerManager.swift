//
//  AudioPlayerManager.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import AVFoundation
import Observation

enum PlaybackStatus: Equatable {
    case idle
    case playing
    case paused
    case ended
}

@MainActor
@Observable
final class AudioPlayerManager {
    private var player: AVPlayer?
    private var endObserver: NSObjectProtocol?
    private var timeObserver: Any?
    private var durationTask: Task<Void, Never>?

    private(set) var queue = PlaybackQueue()
    private(set) var status: PlaybackStatus = .idle
    private(set) var currentTime: Double = 0
    private(set) var duration: Double = 0

    var currentMusic: MusicModel? { queue.current }
    var isPlaying: Bool { status == .playing }
    var isPaused: Bool { status == .paused }

    isolated deinit {                       // Swift 6.2 / Xcode 26
        cleanupObservers()
    }

    func play(queue items: [MusicModel], startAt index: Int) {
        guard let track = queue.load(items, startAt: index) else { return }
        playItem(track)
    }

    func pause() {
        guard status == .playing else { return }
        player?.pause()
        status = .paused
    }

    func resume() {
        guard status == .paused else { return }
        player?.play()
        status = .playing
    }

    func restart() {
        guard status == .ended else { return }
        seek(to: 0)
        player?.play()
        status = .playing
    }

    func togglePlayPause() {
        switch status {
        case .playing: pause()
        case .paused:  resume()
        case .ended:   restart()
        case .idle:    break
        }
    }

    func playNext() {
        guard let next = queue.advance() else {
            stopAtEnd()
            return
        }
        playItem(next)
    }

    func playPrevious() {
        if currentTime > 3 { seek(to: 0); return }   // standard "restart current" behavior

        guard let previous = queue.rewind() else { seek(to: 0); return }
        playItem(previous)
    }

    func seek(to time: Double) {
        player?.seek(
            to: CMTime(seconds: time, preferredTimescale: 600),
            toleranceBefore: .zero,
            toleranceAfter: .zero
        )
        currentTime = time
    }

    private func playItem(_ music: MusicModel) {
        guard let url = music.previewUrl else { return }

        cleanupObservers()
        durationTask?.cancel()

        currentTime = 0
        duration = 0
        status = .playing

        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        player?.play()

        observe(item)
        loadDuration(for: item)
    }

    private func observe(_ item: AVPlayerItem) {
        timeObserver = player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.25, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            guard let self, self.player?.currentItem === item else { return }
            self.currentTime = time.seconds
        }

        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            self?.handleTrackEnded()
        }
    }

    private func handleTrackEnded() {
        guard let next = queue.advance() else {
            stopAtEnd()
            return
        }
        playItem(next)
    }

    private func stopAtEnd() {
        player?.pause()
        status = .ended
    }

    private func loadDuration(for item: AVPlayerItem) {
        durationTask = Task { [weak self] in
            guard let loaded = try? await item.asset.load(.duration) else { return }
            guard let self, !Task.isCancelled,
                  self.player?.currentItem === item else { return }   // stale load can't win
            self.duration = loaded.seconds
        }
    }

    private func cleanupObservers() {
        if let endObserver {
            NotificationCenter.default.removeObserver(endObserver)
            self.endObserver = nil
        }
        if let timeObserver {
            player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
    }
}

