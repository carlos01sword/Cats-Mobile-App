//
//  CatsAppApp.swift
//  CatsApp
//
//  Created by Carlos Costa on 01/08/2025.
//

import SwiftUI
import SwiftData

@main
struct CatsAppApp: App {
    @StateObject private var viewModel = CatListViewModel()
    var body: some Scene {
        WindowGroup {
            TabView {
                CatDataView()
                    .tabItem { Label("All Breeds", systemImage: "list.bullet") }
                FavoritesView()
                    .tabItem { Label("Favorites", systemImage: "star.fill") }
            }
            .environmentObject(viewModel)
            .modelContainer(for: CatBreed.self)
        }
    }
}
