//
//  FavoritesViews.swift
//  CatsApp
//
//  Created by Carlos Costa on 05/08/2025.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var favoritesState: FavoritesState
    @StateObject private var viewModel: FavoritesViewModel
    @State private var selectedBreed: CatBreed?

    init(favoritesState: FavoritesState) {
        _viewModel = StateObject(wrappedValue: FavoritesViewModel(favoritesState: favoritesState))
    }

    var body: some View {
        NavigationStack {
            if viewModel.favoriteBreeds.isEmpty {
                FavoritesEmptyStateView()
            } else {
                BreedListView(
                    breeds: viewModel.favoriteBreeds,
                    header: AverageTabView(breeds: viewModel.favoriteBreeds)
                ) { breed in
                    AnyView(
                        BreedRowView(breed: breed, onFavoriteTapped: {
                            viewModel.toggleFavorite(for: breed, context: context)
                        })
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedBreed = breed
                        }
                        .buttonStyle(PlainButtonStyle())
                    )
                }
                .navigationTitle("Favorites")
            }
        }
        .sheet(item: $selectedBreed) { breed in
            DetailsView(breed: breed, favoritesState: favoritesState)
        }
        .onAppear {
            favoritesState.loadFavorites(context: context)
        }
    }
}

#Preview {
    let favoritesState = FavoritesState()
    FavoritesView(favoritesState: favoritesState)
        .modelContainer(for: CatBreed.self, inMemory: true)
        .environmentObject(favoritesState)
}
