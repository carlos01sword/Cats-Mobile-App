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
            if let imageUrl = breed.referenceImageUrl,
               let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Color.gray.opacity(0.1)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            Text(breed.name)
                .font(.headline)
                .foregroundColor(.primary)

            Spacer()

            if let onFavoriteTapped = onFavoriteTapped {
                Image(systemName: breed.isFavorite ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        onFavoriteTapped()
                    }
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
