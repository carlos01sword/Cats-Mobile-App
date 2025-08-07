//
//  ContentView.swift
//  CatsApp
//
//  Created by Carlos Costa on 01/08/2025.
//

import SwiftUI
import SwiftData

struct CatDataView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var viewModel: CatListViewModel
    @State private var selectedBreed: CatBreed?

    var body: some View {
        NavigationView {
            BreedListView(breeds: viewModel.filteredBreeds,header: EmptyView()) { breed in
                AnyView(
                    BreedRowView(breed: breed) {
                        viewModel.toggleFavorite(for: breed, context: context)
                    }
                    .onAppear {
                        if breed == viewModel.filteredBreeds.last {
                            Task { await viewModel.loadMore(context: context) }
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedBreed = breed
                    }
                    )
            }
            .navigationTitle("Cats App")
            .searchable(text: $viewModel.searchText, prompt: "Search breed")
            .alert("Failed to Load Data", isPresented: .constant(viewModel.fetchErrorMessage != nil)) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.fetchErrorMessage ?? "")
            }
            .task {
                await viewModel.refreshBreeds(from: context)

                if viewModel.catBreeds.isEmpty {
                    await viewModel.loadInitial(context: context)
                }
            }
        }
        .sheet(item: $selectedBreed) { breed in
            DetailsView(breed: breed)
        }
    }
}

