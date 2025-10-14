//
//  BreedRowView.swift
//  CatsApp
//
//  Created by Carlos Costa on 06/08/2025.
//

import SwiftUI

struct BreedRowView: View {
    let breed: CatBreed
    let onFavoriteTapped: (() -> Void)?

    var body: some View {
        HStack(spacing: 16) {
            BreedThumbnailView(urlString: breed.referenceImageUrl, imageData: breed.imageData)

            Text(breed.name)
                .font(.headline)
                .foregroundColor(.primary)
                .accessibilityLabel(breed.name)

            Spacer()

            if let onFavoriteTapped = onFavoriteTapped {
                Image(systemName: breed.isFavorite ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .accessibilityLabel(breed.isFavorite ? "Favorited" : "Not favorited")
                    .onTapGesture { onFavoriteTapped() }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color(.systemGray3), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    BreedRowView(breed: MockData.sampleBreed, onFavoriteTapped: { })
}
