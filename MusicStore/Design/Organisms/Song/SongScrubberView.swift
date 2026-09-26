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
    
    @GestureState private var isDragging = false
    @State private var dragValue: Double = 0
    
    private var sliderValue: Binding<Double> {
        Binding(
            get: { isDragging ? dragValue : currentTime },
            set: { dragValue = $0 }
        )
    }
    
    var body: some View {
        VStack(spacing: Spacing.xSmall.points) {
            Slider(
                value: sliderValue,
                in: 0...max(duration, 1)
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .updating($isDragging) { _, state, _ in
                        state = true
                    }
            )
            .onChange(of: isDragging) { _, dragging in
                if dragging {
                    dragValue = currentTime
                } else {
                    onSeek(dragValue)
                }
            }
            
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
