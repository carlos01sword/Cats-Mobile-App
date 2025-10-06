import Foundation
import SwiftData

@MainActor
final class FavoritesState: ObservableObject{
    @Published private(set) var favorites: [CatBreed] = []
    private let repository: BreedsRepositoryProtocol
    
    init(repository: BreedsRepositoryProtocol = BreedsRepository()) {
        self.repository = repository
    }
    
    func loadFavorites(context: ModelContext) {
        do {
            favorites = try repository.fetchFavorites(context: context)
        } catch {
            favorites = []
        }
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
}
