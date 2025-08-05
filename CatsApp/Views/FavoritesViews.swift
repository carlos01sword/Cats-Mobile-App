//
//  FavoritesViews.swift
//  CatsApp
//
//  Created by Carlos Costa on 05/08/2025.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var context
    @Query(
        filter: #Predicate { (breed: CatBreed) in
            breed.isFavorite
        }
    ) private var favoriteBreeds: [CatBreed]
    
    var body: some View {
        NavigationStack {
            List(favoriteBreeds) { breed in
                HStack(spacing: 16) {
                    if let imageUrl = breed.referenceImageUrl,
                       let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(1)
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
                    
                    Spacer()
                }
                .padding(.vertical, 5)
                
            }
            .navigationTitle("Favorites")
        }
    }
}
