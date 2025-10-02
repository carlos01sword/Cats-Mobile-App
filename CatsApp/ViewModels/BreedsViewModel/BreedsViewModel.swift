//
//  CatDataViewModel.swift
//  CatsApp
//
//  Created by Carlos Costa on 03/08/2025.
//

import Foundation
import SwiftData

enum LoadPhase: Equatable {
    case idle
    case initialLoading
    case pageLoading
    case endReached
    case error(String)
}

@MainActor
final class BreedsViewModel: ObservableObject {
    let repository: BreedsRepositoryProtocol
    
    @Published var catBreeds: [CatBreed] = []
    @Published var searchText: String = ""
    @Published private(set) var phase: LoadPhase = .idle

    private(set) var currentPage = 0
    let pageSize = 10
    
    init(repository: BreedsRepositoryProtocol = BreedsRepository()) {
        self.repository = repository
    }
    
    func resetPaging() { currentPage = 0 }
    func advancePage() { currentPage += 1 }
    
    // Derived state
    var isLoading: Bool { phase == .initialLoading || phase == .pageLoading }
    var canLoadMore: Bool { !(phase == .endReached) && !(phase.isTerminalError) }
    var fetchErrorMessage: String? { if case .error(let msg) = phase { return msg } else { return nil } }

    var filteredBreeds: [CatBreed] {
        searchText.isEmpty
            ? catBreeds
            : catBreeds.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }

    var favoriteBreeds: [CatBreed] { catBreeds.filter(\.isFavorite) }

    func toggleFavorite(for breed: CatBreed, context: ModelContext) {
        try? repository.toggleFavorite(breed, context: context)
    }
    
    func transition(to newPhase: LoadPhase) { phase = newPhase }
    
    func shouldLoadMore(after breed: CatBreed) -> Bool {
        guard searchText.isEmpty,
              canLoadMore,
              !isLoading,
              let last = filteredBreeds.last, last.id == breed.id else { return false }
        return true
    }
}

private extension LoadPhase {
    var isTerminalError: Bool { if case .error = self { return true } else { return false } }
}
