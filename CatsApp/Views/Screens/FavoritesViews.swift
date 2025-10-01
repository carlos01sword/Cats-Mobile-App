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
    @EnvironmentObject private var viewModel: CatListViewModel
    @State private var selectedBreed: CatBreed?
    
    var body: some View {
        NavigationView {
            if viewModel.favoriteBreeds.isEmpty {
                Text("No favorites selected yet!")
                    .foregroundStyle(.secondary)
                    .navigationTitle("Favorites")
            } else {
            BreedListView(
                breeds: viewModel.favoriteBreeds,
                header: AvgView(breeds: viewModel.favoriteBreeds)
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
            DetailsView(breed: breed)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: CatBreed.self, configurations: config)
    let vm = CatListViewModel()
    if let sample = MockData.sampleBreed as CatBreed? { 
        sample.isFavorite = true
        vm.catBreeds = [sample]
    }
    return FavoritesView()
        .modelContainer(container)
        .environmentObject(vm)
}
