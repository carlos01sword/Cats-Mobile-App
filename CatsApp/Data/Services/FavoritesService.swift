//
//  FavoritesService.swift
//  CatsApp
//
//  Created by Carlos Costa on 09/10/2025.
//

import Foundation
import SwiftData

struct FavoritesService {
    public internal(set) var fetchFavorites:
        @MainActor (ModelContext) throws -> [CatBreed]
    public internal(set) var toggleFavorite:
        @MainActor (CatBreed, ModelContext) throws -> Void
    public internal(set) var isFavorite:
        @MainActor (CatBreed, ModelContext) throws -> Bool
}

extension FavoritesService {
    static func live(repository: BreedsRepository = BreedsRepository.live())
        -> FavoritesService
    {
        FavoritesService(
            fetchFavorites: { context in
                try repository.fetchFavorites(context)
            },
            toggleFavorite: { breed, context in
                try repository.toggleFavorite(breed, context)
            },
            isFavorite: { breed, context in
                let favorites = try repository.fetchFavorites(context)
                return favorites.contains(where: { $0.id == breed.id })
            }
        )
    }
}
