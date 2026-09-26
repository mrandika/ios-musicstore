//
//  SongTitleView.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct SongTitleView: View {
    var name: String
    var isExplicit: Bool
    
    init(
        name: String,
        isExplicit: Bool
    ) {
        self.name = name
        self.isExplicit = isExplicit
    }
    
    var body: some View {
        HStack(
            alignment: .center,
            spacing: Spacing.small.points
        ) {
            StyledText(
                name, weight: .bold, size: .medium
            )
            
            if isExplicit {
                ExplicitBadgeView()
            }
        }
    }
}

#Preview {
    VStack {
        SongTitleView(name: "City of Stars", isExplicit: false)
        
        SongTitleView(name: "City of Stars", isExplicit: true)
    }
}
