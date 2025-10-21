//
//  BreedTabView.swift
//  CatsApp
//
//  Created by Carlos Costa on 01/10/2025.
//

import SwiftUI

struct BreedTabView: View {
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel

    var body: some View {
        TabView {
            BreedsView(favoritesViewModel: favoritesViewModel)
                .tabItem { Label("All Breeds", systemImage: "list.bullet") }
            FavoritesView()
                .tabItem { Label("Favorites", systemImage: "star.fill") }
        }
    }
}
#if DEBUG
#Preview {
    let favoritesViewModel = FavoritesViewModel()
    BreedTabView()
        .modelContainer(for: CatBreed.self, inMemory: true)
        .environmentObject(favoritesViewModel)
}
#endif
