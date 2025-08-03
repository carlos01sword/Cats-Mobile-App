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
            List(viewModel.catBreeds) { breed in
                VStack() {
                    Text(breed.name)
                        .font(.headline)
                    Text(breed.origin)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(breed.description)
                        .font(.caption)
                }
            }
            .navigationTitle("Cats App")
            .task {
                await viewModel.loadBreeds()
            }
        }
    }
}

