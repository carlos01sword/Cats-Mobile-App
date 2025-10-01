//
//  BreedTabView.swift
//  CatsApp
//
//  Created by Carlos Costa on 01/10/2025.
//

import SwiftUI

struct BreedTabView: View {
    @EnvironmentObject private var viewModel: CatListViewModel
        
    var body: some View {
        TabView {
            CatDataView()
                .tabItem { Label("All Breeds", systemImage: "list.bullet") }
            FavoritesView()
                .tabItem { Label("Favorites", systemImage: "star.fill") }
        }
        .breedSearchable($viewModel.searchText)
    }
}

#Preview {
    BreedTabView()
        .modelContainer(for: CatBreed.self, inMemory: true)
        .environmentObject(CatListViewModel())
}
