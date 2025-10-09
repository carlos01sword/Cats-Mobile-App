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
    let favoritesViewModel: FavoritesViewModel
    let searchService: SearchServiceProtocol
    
    @Published var catBreeds: [CatBreed] = []
    @Published var searchText: String = ""
    @Published private(set) var state: ViewState = .idle

    var currentPage = 0
    let pageSize = 10
    
    init(repository: BreedsRepositoryProtocol = BreedsRepository(), favoritesViewModel: FavoritesViewModel) {
        self.repository = repository
        self.favoritesViewModel = favoritesViewModel
        self.searchService = SearchService()
    }
    
    func resetPaging() { currentPage = 0 }
    func advancePage() { currentPage += 1 }
    
    // Derived state
    var isLoading: Bool { state == .initialLoading || state == .pageLoading }
    var canLoadMore: Bool { !(state == .endReached) && !(state.isTerminalError) }
    var fetchErrorMessage: String? { if case .error(let err) = state { return err.errorDescription } else { return nil } }

    var filteredBreeds: [CatBreed] {
        searchService.searchBreeds(query: searchText, in: catBreeds)
    }

    //FavoritesState for favorite breeds
    var favoriteBreeds: [CatBreed] { favoritesViewModel.favorites }
    
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
