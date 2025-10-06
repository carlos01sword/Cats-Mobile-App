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
    @EnvironmentObject private var favoritesState: FavoritesState
    @StateObject private var viewModel: BreedsViewModel
    @State private var selectedBreed: CatBreed?

    init(favoritesState: FavoritesState) {
        _viewModel = StateObject(wrappedValue: BreedsViewModel(favoritesState: favoritesState))
    }

    var body: some View {
        NavigationStack {
            Group {
                if !viewModel.searchText.isEmpty && viewModel.filteredBreeds.isEmpty {
                    SearchEmptyStateView(searchText: viewModel.searchText)
                } else {
                    BreedListView(
                        breeds: viewModel.filteredBreeds,
                        header: EmptyView()
                    ) { breed in
                        AnyView(
                            BreedRowView(breed: breed) {
                                viewModel.favoritesState.toggleFavorite(for: breed, context: context)
                            }
                            .onAppear {
                                if viewModel.shouldLoadMore(after: breed) {
                                    Task { await viewModel.loadMore(context: context) }
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture { selectedBreed = breed }
                        )
                    }
                }
            }
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
            .task {
                viewModel.loadCachedIfAvailable(context: context)
                if viewModel.catBreeds.isEmpty {
                    await viewModel.loadInitial(context: context)
                }
            }
        }
        .sheet(item: $selectedBreed) { breed in
            DetailsView(breed: breed, favoritesState: favoritesState)
        }
    }
}

#Preview {
    let favoritesState = FavoritesState()
    BreedsView(favoritesState: favoritesState)
        .modelContainer(for: CatBreed.self, inMemory: true)
        .environmentObject(favoritesState)
}
