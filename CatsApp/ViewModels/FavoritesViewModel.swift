//
//  FavoritesViewModel.swift
//  CatsApp
//
//  Created by Carlos Costa on 06/08/2025.
//

import Foundation
import SwiftData

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var favoriteBreeds: [CatBreed] = []

    func loadFavorites(from context: ModelContext) {
        let descriptor = FetchDescriptor<CatBreed>(
            predicate: #Predicate { $0.isFavorite }
        )

        if let fetched = try? context.fetch(descriptor) {
            favoriteBreeds = fetched
        }
    }
}
