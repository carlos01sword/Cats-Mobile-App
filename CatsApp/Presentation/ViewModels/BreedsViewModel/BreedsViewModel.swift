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
    let repository: BreedsRepository
    let favoritesViewModel: FavoritesViewModel
    let searchService: SearchService

    @Published var catBreeds: [CatBreed] = []
    @Published var searchText: String = ""
    @Published private(set) var state: ViewState = .idle

    var currentPage = 0
    let pageSize = 10

    init(
        repository: BreedsRepository = BreedsRepository.live(),
        favoritesViewModel: FavoritesViewModel
    ) {
        self.repository = repository
        self.favoritesViewModel = favoritesViewModel
        self.searchService = SearchService.live
    }

    func resetPaging() { currentPage = 0 }
    func advancePage() { currentPage += 1 }

    // Derived state
    var isLoading: Bool { state == .initialLoading || state == .pageLoading }
    var canLoadMore: Bool {
        !(state == .endReached) && !(state.isTerminalError)
    }
    var fetchErrorMessage: String? {
        if case .error(let err) = state {
            return err.errorDescription
        } else {
            return nil
        }
    }

    var filteredBreeds: [CatBreed] {
        let filteredBreeds = searchService.searchBreeds(searchText, catBreeds)
        return filteredBreeds
    }

    var favoriteBreeds: [CatBreed] { favoritesViewModel.favorites }

    func transition(to newPhase: ViewState) { state = newPhase }

    func shouldLoadMore(after breed: CatBreed) -> Bool {
        guard searchText.isEmpty,
            canLoadMore,
            !isLoading,
            let last = filteredBreeds.last, last.id == breed.id
        else { return false }
        return true
    }
}

extension ViewState {
    fileprivate var isTerminalError: Bool {
        if case .error = self { return true } else { return false }
    }
}
