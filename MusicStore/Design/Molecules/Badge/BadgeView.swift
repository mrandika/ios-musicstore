//
//  BadgeView.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct BadgeView: View {
    var text: String
    var weight: FontWeight
    var size: FontSize
    var foregroundStyle: Color
    var backgroundColor: Color
    
    init(
        _ text: String,
        weight: FontWeight = .regular,
        size: FontSize = .xSmall,
        foregroundStyle: Color,
        backgroundColor: Color
    ) {
        self.text = text
        self.weight = weight
        self.size = size
        self.foregroundStyle = foregroundStyle
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        StyledText(
            text,
            weight: weight,
            size: size
        ).padding(
            Spacing.xSmall.points
        ).background(
            backgroundColor
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: CornerRadius.small.points
                    )
                )
        )
    }
}

#Preview {
    BadgeView(
        "Example Badge",
        foregroundStyle: .black,
        backgroundColor: .gray.opacity(0.5)
    )
}
