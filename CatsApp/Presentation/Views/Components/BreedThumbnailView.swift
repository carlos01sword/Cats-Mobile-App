//  BreedThumbnailView.swift
//  CatsApp
//
//  Created by Carlos on 01/10/2025.
//
import SwiftUI

struct BreedThumbnailView: View {
    let urlString: String?
    let imageData: Data?
    var size: CGFloat = 60
    var cornerRadius: CGFloat = 8

    var body: some View {
        Group {
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else if let urlString, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ImageLoader(cornerRadius: cornerRadius)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure(_):
                        Image(systemName: "pawprint.fill")
                            .resizable()
                            .scaledToFit()
                    @unknown default:
                        Color.red.opacity(0.2)
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .accessibilityHidden(true)
    }
}

#Preview {
    HStack(spacing: 20) {
        BreedThumbnailView(urlString: "https://cdn2.thecatapi.com/images/abc.jpg", imageData: nil)
        BreedThumbnailView(urlString: nil, imageData: nil)
        BreedThumbnailView(urlString: "invalid-url", imageData: nil)
    }
    .padding()
}
