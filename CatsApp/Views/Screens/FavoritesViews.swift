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
    @StateObject private var viewModel = FavoritesViewModel()
    @State private var selectedBreed: CatBreed?
    
    var body: some View {
        NavigationView {
            BreedListView(
                breeds: viewModel.favoriteBreeds,
                header: AvgView(breeds: viewModel.favoriteBreeds)
            ) { breed in
                AnyView(
                    BreedRowView(breed: breed,onFavoriteTapped: nil)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedBreed = breed
                    }
                    .buttonStyle(PlainButtonStyle())
                )
            }
            .navigationTitle("Favorites")
            .onAppear {
                viewModel.loadFavorites(from: context)
            }
        }
        .sheet(item: $selectedBreed) { breed in
            DetailsView(breed: breed)
        }
        .onChange(of: selectedBreed) {
            if selectedBreed == nil {
                viewModel.loadFavorites(from: context)
            }
        }
    }
}
