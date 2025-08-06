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
    @Query private var storedBreeds: [CatBreed]
    @StateObject private var viewModel = CatListViewModel()

    var body: some View {
           NavigationView {
               ScrollView {
                   VStack(spacing: 16) {
                       ForEach(viewModel.filteredBreeds) { breed in
                           NavigationLink(destination: DetailsView(breed: breed)) {
                               BreedRowView(breed: breed) {viewModel.toggleFavorite(for: breed, context: context)}
                           }
                       }
                   }
                   .padding()
               }
               .navigationTitle("Cats App")
               .alert("Failed to Load Data", isPresented: .constant(viewModel.fetchErrorMessage != nil), actions: {
                   Button("OK") {
                       viewModel.fetchErrorMessage = nil
                   }
               }, message: {
                   Text(viewModel.fetchErrorMessage ?? "")
               })
               .searchable(text: $viewModel.searchText, prompt: "Search breed")
               .task {
                   if storedBreeds.isEmpty {
                       await viewModel.loadBreeds(context: context)
                   } else {
                       viewModel.catBreeds = storedBreeds
                   }
               }
           }
       }
}

