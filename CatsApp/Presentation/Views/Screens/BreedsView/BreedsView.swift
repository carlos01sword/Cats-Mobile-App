//
//  ContentView.swift
//  CatsApp
//
//  Created by Carlos Costa on 01/08/2025.
//

import SwiftData
import SwiftUI

struct BreedsView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @StateObject private var viewModel: BreedsViewModel
    @State private var selectedBreed: CatBreed?

    init(favoritesViewModel: FavoritesViewModel) {
        _viewModel = StateObject(wrappedValue: BreedsViewModel(favoritesViewModel: FavoritesViewModel()))
    }

    var body: some View {
        NavigationStack {
            content
                .breedSearchable($viewModel.searchText)
                .navigationTitle("Cats App")
                .alert(
                    "Failed to Load Data",
                    isPresented: .constant(viewModel.fetchErrorMessage != nil)
                ) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(viewModel.fetchErrorMessage ?? "")
                }
                .task { initialLoadIfNeeded() }
        }
        .sheet(item: $selectedBreed) { breed in
            DetailsView(breed: breed, favoritesViewModel: favoritesViewModel)
        }
    }
}

private extension BreedsView {
    var content: some View {
        Group {
            if isSearchEmptyState {
                SearchEmptyStateView(searchText: viewModel.searchText)
            } else {
                BreedListView(
                    breeds: viewModel.filteredBreeds,
                    onSelect: { selectedBreed = $0 },
                    onFavorite: { favoritesViewModel.toggleFavorite(for: $0, context: context) },
                    onRowAppear: handleRowAppear
                )
            }
        }
    }

    var isSearchEmptyState: Bool {
        !viewModel.searchText.isEmpty && viewModel.filteredBreeds.isEmpty
    }

    func handleRowAppear(_ breed: CatBreed) {
        guard viewModel.shouldLoadMore(after: breed) else { return }
        Task { await viewModel.loadMore(context: context) }
    }

    func initialLoadIfNeeded() {
        viewModel.loadCachedIfAvailable(context: context)
        if viewModel.catBreeds.isEmpty {
            Task { await viewModel.loadInitial(context: context) }
        }
    }
}

#Preview {
    let favoritesViewModel = FavoritesViewModel()
    BreedsView(favoritesViewModel: favoritesViewModel)
        .modelContainer(for: CatBreed.self, inMemory: true)
        .environmentObject(favoritesViewModel)
}
