//
//  ContentView.swift
//  CatsApp
//
//  Created by Carlos Costa on 01/08/2025.
//

import SwiftUI

struct CatDataView: View {
    @StateObject private var viewModel = CatListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.filteredBreeds) { breed in
                HStack(spacing: 16) {
                    if let imageUrl = breed.referenceImageUrl,
                       let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(1)
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    } else {
                        Color.gray.opacity(0.1)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    Text(breed.name)
                        .font(.headline)

                    Spacer()

                    Image(systemName: breed.isFavorite ? "star.fill" : "star")
                        .foregroundColor(breed.isFavorite ? .yellow : .gray)
                        .onTapGesture {
                            viewModel.toggleFavorite(for: breed)
                        }
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("Cats App")
            .searchable(text: $viewModel.searchText, prompt: "Search breed")
            .task {
                await viewModel.loadBreeds()
            }
        }
    }
}
