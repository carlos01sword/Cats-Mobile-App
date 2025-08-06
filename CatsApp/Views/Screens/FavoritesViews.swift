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


    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    AvgView(breeds: viewModel.favoriteBreeds)

                    ForEach(viewModel.favoriteBreeds) { breed in
                        NavigationLink(destination: DetailsView(breed: breed)) {
                            BreedRowView(breed: breed, onFavoriteTapped: nil)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Favorites")
            .onAppear {
                viewModel.loadFavorites(from: context)
            }
            .task {
                viewModel.loadFavorites(from: context)
            }
            .background(Color(.systemBackground))
        }
    }
}
