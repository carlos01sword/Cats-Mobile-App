import Foundation
import SwiftData

@MainActor
final class FavoritesViewModel: ObservableObject {
    let favoritesState: FavoritesState
    
    init(favoritesState: FavoritesState) {
        self.favoritesState = favoritesState
    }
    
    var favoriteBreeds: [CatBreed] {
        favoritesState.favorites
    }
    
    func toggleFavorite(for breed: CatBreed, context: ModelContext) {
        favoritesState.toggleFavorite(for: breed, context: context)
    }
    
    func isFavorite(_ breed: CatBreed) -> Bool {
        favoritesState.isFavorite(breed)
    }
}
