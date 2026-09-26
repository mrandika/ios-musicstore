//
//  StyledText.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct StyledText: View {
    var text: String
    var weight: FontWeight
    var size: FontSize
    
    init(
        _ text: String,
        weight: FontWeight = .regular,
        size: FontSize = .xSmall
    ) {
        self.text = text
        self.weight = weight
        self.size = size
    }
    
    var body: some View {
        Text(text)
            .font(
                .system(size: size.points, weight: weight.weight)
            )
    }
}

#Preview {
    StyledText("Example")
}
