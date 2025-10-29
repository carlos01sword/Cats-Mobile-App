import SwiftData
import SwiftUI

struct FavoritesView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var viewModel: FavoritesViewModel
    @State private var selectedBreed: CatBreed?

    var body: some View {
        NavigationStack {
            if viewModel.favoriteBreeds.isEmpty {
                FavoritesEmptyStateView()
            } else {
                BreedListView(
                    breeds: viewModel.favoriteBreeds,
                    header: AverageTabView(breeds: viewModel.favoriteBreeds),
                    onSelect: { selectedBreed = $0 },
                    onFavorite: {
                        viewModel.toggleFavorite(for: $0, context: context)
                    }
                )
                .navigationTitle("Favorites")
            }
        }
        .sheet(item: $selectedBreed) { breed in
            DetailsView(breed: breed, favoritesViewModel: viewModel)
        }
        .onAppear { viewModel.loadFavorites(context: context) }
    }
}
#if DEBUG
#Preview {
    FavoritesView()
        .modelContainer(for: CatBreed.self, inMemory: true)
        .environmentObject(FavoritesViewModel())
}
#endif
