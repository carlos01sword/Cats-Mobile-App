import SwiftData
import SwiftUI

@main
struct CatsAppApp: App {
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    
    var body: some Scene {
        WindowGroup {
            BreedTabView()
                .environmentObject(favoritesViewModel)
                .modelContainer(for: CatBreed.self)
        }
    }
}
