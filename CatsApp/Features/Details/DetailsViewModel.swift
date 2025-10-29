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

    func isFavorite(context: ModelContext) -> Bool {
        favoritesViewModel.isFavorite(breed, context: context)
    }

    var name: String { breed.name }
    var origin: String { breed.origin }
    var temperament: String { breed.temperament }
    var breedDescription: String { breed.breedDescription }
    func favoriteButtonLabel(context: ModelContext) -> String {
        isFavorite(context: context)
            ? "Remove from Favorites" : "Add to Favorites"
    }
    func favoriteButtonColor(context: ModelContext) -> Color {
        isFavorite(context: context) ? .red : .blue
    }
}
