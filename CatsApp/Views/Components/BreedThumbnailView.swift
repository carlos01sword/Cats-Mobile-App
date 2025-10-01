//  BreedThumbnailView.swift
//  CatsApp
//
//  Created by Refactor on 01/10/2025.
//
import SwiftUI

struct BreedThumbnailView: View {
    let urlString: String?
    var size: CGFloat = 60
    var cornerRadius: CGFloat = 8

    var body: some View {
        Group {
            if let urlString, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
            } else {
                Color.gray.opacity(0.1)
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .accessibilityHidden(true)
    }
}

#Preview {
    HStack(spacing: 20) {
        BreedThumbnailView(urlString: "https://cdn2.thecatapi.com/images/abc.jpg")
        BreedThumbnailView(urlString: nil)
    }
    .padding()
}
