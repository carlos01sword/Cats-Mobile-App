import Foundation
import SwiftData

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var favorites: [CatBreed] = []
    private let service: FavoritesService

    init(service: FavoritesService = FavoritesService.live()) {
        self.service = service
    }

    var favoriteBreeds: [CatBreed] {
        favorites
    }

    func toggleFavorite(for breed: CatBreed, context: ModelContext) {
        do {
            try service.toggleFavorite(breed, context)
            loadFavorites(context: context)
        } catch {
            print("Failed to toggle favorite: \(error)")
        }
    }

    func isFavorite(_ breed: CatBreed, context: ModelContext) -> Bool {
        do {
            return try service.isFavorite(breed, context)
        } catch {
            return false
        }
    }

    func loadFavorites(context: ModelContext) {
        do {
            favorites = try service.fetchFavorites(context)
        } catch {
            favorites = []
        }
    }
}
