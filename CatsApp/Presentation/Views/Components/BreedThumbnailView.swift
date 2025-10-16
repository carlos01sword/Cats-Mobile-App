//  BreedThumbnailView.swift
//  CatsApp
//
//  Created by Carlos on 01/10/2025.
//
import SwiftUI

struct BreedThumbnailView: View {
    let urlString: String?
    let imageData: Data?

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
                        ImageLoader()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure(_):
                        Image(systemName: "pawprint.fill")
                            .resizable()
                            .scaledToFit()
                    @unknown default:
                        Color.red.opacity(ConstantsUI.shimmerBaseOpacity)
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(width: .breedThumbnailSize, height: .breedThumbnailSize)
        .clipShape(
            RoundedRectangle(cornerRadius: ConstantsUI.defaultCornerRadius)
        )
        .accessibilityHidden(true)
    }
}

private extension CGFloat {
    static let breedThumbnailSize: Self = 60
}

#Preview {
    HStack(spacing: ConstantsUI.largeVerticalSpacing) {
        BreedThumbnailView(
            urlString: "https://cdn2.thecatapi.com/images/abc.jpg",
            imageData: nil
        )
        BreedThumbnailView(urlString: nil, imageData: nil)
        BreedThumbnailView(urlString: "invalid-url", imageData: nil)
    }
    .padding()
}
