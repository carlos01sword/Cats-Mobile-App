//
//  FavoritesService.swift
//  CatsApp
//
//  Created by Carlos Costa on 09/10/2025.
//

import Foundation
import SwiftData

struct FavoritesService {

    var fetchFavorites: @MainActor (ModelContext) throws -> [CatBreed]
    var toggleFavorite: @MainActor (CatBreed, ModelContext) throws -> Void
    var isFavorite: @MainActor (CatBreed, ModelContext) throws -> Bool

    static func live(repository: BreedsRepository = BreedsRepository())
        -> FavoritesService
    {
        FavoritesService(
            fetchFavorites: { context in
                try repository.fetchFavorites(context: context)
            },
            toggleFavorite: { breed, context in
                try repository.toggleFavorite(breed, context: context)
            },
            isFavorite: { breed, context in
                let favorites = try repository.fetchFavorites(context: context)
                return favorites.contains(where: { $0.id == breed.id })
            }
        )
    }
}
