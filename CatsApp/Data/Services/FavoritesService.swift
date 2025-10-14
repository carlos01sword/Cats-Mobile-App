//
//  FavoritesService.swift
//  CatsApp
//
//  Created by Carlos Costa on 09/10/2025.
//

import Foundation
import SwiftData

protocol FavoritesServiceProtocol {
    @MainActor
    func fetchFavorites(context: ModelContext) throws -> [CatBreed]
    @MainActor
    func toggleFavorite(_ breed: CatBreed, context: ModelContext) throws
    @MainActor
    func isFavorite(_ breed: CatBreed, context: ModelContext) throws -> Bool
}

struct FavoritesService: FavoritesServiceProtocol {
    private let repository: BreedsRepositoryProtocol
    
    init(repository: BreedsRepositoryProtocol = BreedsRepository()) {
        self.repository = repository
    }
    
    @MainActor
    func fetchFavorites(context: ModelContext) throws -> [CatBreed] {
        try repository.fetchFavorites(context: context)
    }
    
    @MainActor
    func toggleFavorite(_ breed: CatBreed, context: ModelContext) throws {
        try repository.toggleFavorite(breed, context: context)
    }
    
    @MainActor
    func isFavorite(_ breed: CatBreed, context: ModelContext) throws -> Bool {
        let favorites = try fetchFavorites(context: context)
        return favorites.contains(where: { $0.id == breed.id })
    }
}
