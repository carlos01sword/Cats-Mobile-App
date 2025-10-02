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
    private let service: BreedsFetching
    
    @Published var catBreeds: [CatBreed] = []
    @Published var searchText: String = ""
    @Published private(set) var phase: LoadPhase = .idle

    private(set) var currentPage = 0
    let pageSize = 10
    
    func resetPaging() { currentPage = 0 }
    func advancePage() { currentPage += 1 }
    
    // Derived state
    var isLoading: Bool { phase == .initialLoading || phase == .pageLoading }
    var canLoadMore: Bool { !(phase == .endReached) && !(phase.isTerminalError) }
    var fetchErrorMessage: String? { if case .error(let msg) = phase { return msg } else { return nil } }

    init(service: BreedsFetching = BreedsDataService()) {
        self.service = service
    }

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
    }

    func refreshBreeds(from context: ModelContext) async {
        let descriptor = FetchDescriptor<CatBreed>()
        if let fetched = try? context.fetch(descriptor) {
            catBreeds = fetched.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
    }
    
    func breedExists(with id: String, in context: ModelContext) -> Bool {
        let predicate = #Predicate<CatBreed> { $0.id == id }
        let descriptor = FetchDescriptor<CatBreed>(predicate: predicate)
        return (try? context.fetch(descriptor).first) != nil
    }
    
    func fetchPage(page: Int, limit: Int) async -> Result<[BreedsDataService.CatBreed], Error> {
        await service.fetchCatsData(page: page, limit: limit)
    }
    
    func transition(to newPhase: LoadPhase) {
        phase = newPhase
    }
    
    func shouldLoadMore(after breed: CatBreed) -> Bool {
        guard searchText.isEmpty,
              canLoadMore,
              !isLoading,
              let last = filteredBreeds.last, last.id == breed.id else { return false }
        return true
    }
}

private extension LoadPhase {
    var isTerminalError: Bool {
        if case .error = self { return true } else { return false }
    }
}
