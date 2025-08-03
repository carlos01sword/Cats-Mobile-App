//
//  CatDataViewModel.swift
//  CatsApp
//
//  Created by Carlos Costa on 03/08/2025.
//

import Foundation
import Combine

@MainActor
final class CatListViewModel: ObservableObject {
    @Published var catBreeds: [CatBreed] = []
    @Published var searchText: String = ""

    private let favoritesKey = "favoriteCatIDs"

    var filteredBreeds: [CatBreed] {
        if searchText.isEmpty {
            return catBreeds
        } else {
            return catBreeds.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    func loadBreeds() async {
        var breeds = await CatDataService().fetchCatsData()
        let favoriteIDs = loadFavoriteIDs()

        for i in breeds.indices {
            if favoriteIDs.contains(breeds[i].id) {
                breeds[i].isFavorite = true
            }
        }

        self.catBreeds = breeds
    }

    func toggleFavorite(for breed: CatBreed) {
        guard let index = catBreeds.firstIndex(where: { $0.id == breed.id }) else { return }
        catBreeds[index].isFavorite.toggle()

        saveFavoriteIDs()
    }

    private func saveFavoriteIDs() {
        let ids = catBreeds.filter { $0.isFavorite }.map { $0.id }
        UserDefaults.standard.set(ids, forKey: favoritesKey)
    }

    private func loadFavoriteIDs() -> [String] {
        UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
    }
}
