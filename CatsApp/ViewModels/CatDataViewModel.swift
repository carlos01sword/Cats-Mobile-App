//
//  CatDataViewModel.swift
//  CatsApp
//
//  Created by Carlos Costa on 03/08/2025.
//

import Foundation
import SwiftData

@MainActor
final class CatListViewModel: ObservableObject {
    
    @Published var catBreeds: [CatBreed] = []
    @Published var searchText: String = ""
    @Published var fetchErrorMessage: String?

    var currentPage = 0
    let pageSize = 10
    var isLoading = false
    var canLoadMore = true

    var filteredBreeds: [CatBreed] {
        searchText.isEmpty
            ? catBreeds
            : catBreeds.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }

    var favoriteBreeds: [CatBreed] {
        catBreeds.filter(\.isFavorite)
    }

    func toggleFavorite(for breed: CatBreed, context: ModelContext) {
        breed.isFavorite.toggle()
        try? context.save()
        Task {
            await refreshBreeds(from: context)
        }
    }

    func refreshBreeds(from context: ModelContext) async {
        let descriptor = FetchDescriptor<CatBreed>()
        if let fetched = try? context.fetch(descriptor) {
            catBreeds = fetched
        }
    }
    
    func breedExists(with id: String, in context: ModelContext) -> Bool {
        let predicate = #Predicate<CatBreed> { $0.id == id }
        let descriptor = FetchDescriptor<CatBreed>(predicate: predicate)
        return (try? context.fetch(descriptor).first) != nil
    }
}
