import Foundation
import SwiftData
import SwiftUI

@MainActor
final class DetailsViewModel: ObservableObject {
    let favoritesState: FavoritesState
    let breed: CatBreed
    
    init(breed: CatBreed, favoritesState: FavoritesState) {
        self.breed = breed
        self.favoritesState = favoritesState
    }
    
    func toggleFavorite(context: ModelContext) {
        favoritesState.toggleFavorite(for: breed, context: context)
    }
    
    var isFavorite: Bool {
        favoritesState.isFavorite(breed)
    }
    
    var name: String { breed.name }
    var origin: String { breed.origin }
    var temperament: String { breed.temperament }
    var breedDescription: String { breed.breedDescription }

    var favoriteButtonLabel: String {
        isFavorite ? "Remove from Favorites" : "Add to Favorites"
    }

    var favoriteButtonColor: Color {
        isFavorite ? .red : .blue
    }
}
