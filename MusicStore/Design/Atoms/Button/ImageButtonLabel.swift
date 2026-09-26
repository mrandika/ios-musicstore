//
//  ImageButtonLabel.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct ImageButtonLabel: View {
    var systemName: String
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color.black)
    }
}

#Preview {
    Button(action: {
        debugPrint("Tapped!")
    }, label: {
        ImageButtonLabel(systemName: "play.fill")
            .frame(width: 12)
    })
}
