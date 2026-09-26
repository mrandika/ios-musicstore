//
//  ExplicitBadgeView.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct ExplicitBadgeView: View {
    var body: some View {
        BadgeView(
            "E",
            size: .xxSmall,
            foregroundStyle: .black,
            backgroundColor: .gray.opacity(0.2)
        )
    }
}

#Preview {
    ExplicitBadgeView()
}
