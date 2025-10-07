//
//  CatDataViewModel.swift
//  CatsApp
//
//  Created by Carlos Costa on 03/08/2025.
//

import Foundation
import SwiftData

enum ViewState: Equatable {
    case idle
    case initialLoading
    case pageLoading
    case endReached
    case error(DomainError)
}

@MainActor
final class BreedsViewModel: ObservableObject {
    let repository: BreedsRepositoryProtocol
    let favoritesState: FavoritesState
    
    @Published var catBreeds: [CatBreed] = []
    @Published var searchText: String = ""
    @Published private(set) var state: ViewState = .idle

    var currentPage = 0
    let pageSize = 10
    
    init(repository: BreedsRepositoryProtocol = BreedsRepository(), favoritesState: FavoritesState) {
        self.repository = repository
        self.favoritesState = favoritesState
    }
    
    func resetPaging() { currentPage = 0 }
    func advancePage() { currentPage += 1 }
    
    // Derived state
    var isLoading: Bool { state == .initialLoading || state == .pageLoading }
    var canLoadMore: Bool { !(state == .endReached) && !(state.isTerminalError) }
    var fetchErrorMessage: String? { if case .error(let err) = state { return err.errorDescription } else { return nil } }

    var filteredBreeds: [CatBreed] {
        searchText.isEmpty
            ? catBreeds
            : catBreeds.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }

    //FavoritesState for favorite breeds
    var favoriteBreeds: [CatBreed] { favoritesState.favorites }
    
    func transition(to newPhase: ViewState) { state = newPhase }
    
    func shouldLoadMore(after breed: CatBreed) -> Bool {
        guard searchText.isEmpty,
              canLoadMore,
              !isLoading,
              let last = filteredBreeds.last, last.id == breed.id else { return false }
        return true
    }
}

private extension ViewState {
    var isTerminalError: Bool { if case .error = self { return true } else { return false } }
}
