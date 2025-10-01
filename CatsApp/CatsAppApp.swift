//
//  CatsAppApp.swift
//  CatsApp
//
//  Created by Carlos Costa on 01/08/2025.
//

import SwiftData
import SwiftUI

@main
struct CatsAppApp: App {
    @StateObject private var viewModel = CatListViewModel()
    var body: some Scene {
        WindowGroup {
            BreedTabView()
                .environmentObject(viewModel)
                .modelContainer(for: CatBreed.self)
        }
    }
}
