//
//  SongScrubberView.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct SongScrubberView: View {
    var currentTime: Double
    var duration: Double
    var onSeek: (Double) -> Void
    
    @State private var isDragging = false
    @State private var dragValue: Double = 0
    
    var body: some View {
        VStack(spacing: Spacing.xSmall.points) {
            Slider(
                value: Binding(
                    get: { isDragging ? dragValue : currentTime },
                    set: { newValue in
                        isDragging = true
                        dragValue = newValue
                    }
                ),
                in: 0...max(duration, 1),
                onEditingChanged: { editing in
                    if !editing {
                        onSeek(dragValue)
                        isDragging = false
                    }
                }
            )
            
            HStack {
                Text(formatTime(isDragging ? dragValue : currentTime))
                Spacer()
                Text(formatTime(duration))
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
    
    private func formatTime(_ seconds: Double) -> String {
        guard seconds.isFinite, seconds >= 0 else { return "0:00" }
        let totalSeconds = Int(seconds)
        
        return String(format: "%d:%02d", totalSeconds / 60, totalSeconds % 60)
    }
}

#Preview {
    SongScrubberView(currentTime: 0, duration: 120, onSeek: { value in
        debugPrint("Scrubbed to \(value)")
    })
}
