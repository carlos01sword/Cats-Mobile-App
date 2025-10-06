//
//  BreedTabView.swift
//  CatsApp
//
//  Created by Carlos Costa on 01/10/2025.
//

import SwiftUI

struct BreedTabView: View {
    @EnvironmentObject private var favoritesState: FavoritesState
    
    var body: some View {
        TabView {
            BreedsView(favoritesState: favoritesState)
                .tabItem { Label("All Breeds", systemImage: "list.bullet") }
            FavoritesView(favoritesState: favoritesState)
                .tabItem { Label("Favorites", systemImage: "star.fill") }
        }
    }
}

#Preview {
    let favoritesState = FavoritesState()
    BreedTabView()
        .modelContainer(for: CatBreed.self, inMemory: true)
        .environmentObject(favoritesState)
}
