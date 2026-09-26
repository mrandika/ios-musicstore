//
//  RemoteImageView.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

struct RemoteImageView: View {
    var imageUrl: URL?
    
    var width: CGFloat
    var height: CGFloat
    
    init(
        _ imageUrl: URL? = nil,
        width: CGFloat = 100,
        heigt: CGFloat = 100
    ) {
        self.imageUrl = imageUrl
        self.width = width
        self.height = heigt
    }
    
    var body: some View {
        AsyncImage(url: imageUrl) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: CornerRadius.medium.points
                        )
                    )
            case .failure(let error):
                Image(systemName: "wifi.slash")
            @unknown default:
                EmptyView()
            }
        }.frame(width: width, height: height)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: CornerRadius.medium.points
                )
            )
    }
}

#Preview {
    VStack {
        RemoteImageView(
            URL(
                string: "https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/bb/47/a3/bb47a36e-57b8-9260-f9a4-d09851145c45/00602557100556.rgb.jpg/100x100bb.jpg"
            )
        )
        
        RemoteImageView(
            URL(
                string: "https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/bb/47/a3/bb47a36e-57b8-9260-f9a4-d09851145c45/00602557100556.rgb.jpg/100x100bb.jpg"
            ),
            width: 50
        )
    }
}
