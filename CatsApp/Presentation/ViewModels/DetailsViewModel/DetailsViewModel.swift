import Foundation
import SwiftData
import SwiftUI

@MainActor
final class DetailsViewModel: ObservableObject {
    let favoritesViewModel: FavoritesViewModel
    let breed: CatBreed
    
    init(breed: CatBreed, favoritesViewModel: FavoritesViewModel) {
        self.breed = breed
        self.favoritesViewModel = favoritesViewModel
    }
    
    func toggleFavorite(context: ModelContext) {
        favoritesViewModel.toggleFavorite(for: breed, context: context)
    }
    
    var isFavorite: Bool {
        favoritesViewModel.isFavorite(breed)
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
