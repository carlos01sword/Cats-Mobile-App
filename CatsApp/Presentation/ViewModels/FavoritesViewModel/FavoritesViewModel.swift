import Foundation
import SwiftData

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var favorites: [CatBreed] = []
    private let repository: BreedsRepositoryProtocol
    
    init(repository: BreedsRepositoryProtocol = BreedsRepository()) {
        self.repository = repository
    }
    
    var favoriteBreeds: [CatBreed] {
        favorites
    }
    
    func toggleFavorite(for breed: CatBreed, context: ModelContext) {
        do {
            try repository.toggleFavorite(breed, context: context)
            loadFavorites(context: context)
        } catch {
            print("Failed to toggle favorite: \(error)")
        }
    }
    
    func isFavorite(_ breed: CatBreed) -> Bool {
        favorites.contains(where: { $0.id == breed.id })
    }
    
    func loadFavorites(context: ModelContext) {
        do {
            favorites = try repository.fetchFavorites(context: context)
        } catch {
            favorites = []
        }
    }
}
