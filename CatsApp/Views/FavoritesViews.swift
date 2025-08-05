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
                Text(breed.name)
            }
            .navigationTitle("Favorites")
        }
    }
}
