//
//  DetailsView.swift
//  CatsApp
//
//  Created by Carlos Costa on 05/08/2025.
//

import SwiftUI
import SwiftData

struct DetailsView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @StateObject private var viewModel: DetailsViewModel
    
    init(breed: CatBreed, favoritesViewModel: FavoritesViewModel) {
        _viewModel = StateObject(wrappedValue: DetailsViewModel(breed: breed, favoritesViewModel: favoritesViewModel))
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Spacer(minLength: 32)
                    cardTitle
                    
                    DetailsCardView(
                        origin: viewModel.origin,
                        temperament: viewModel.temperament,
                        breedDescription: viewModel.breedDescription
                    )
                    
                    Spacer(minLength: 32)
                }
                .padding()
            }
            FavoritesButton(viewModel: viewModel)
        }
    }
    
    private var cardTitle: some View {
        Text(viewModel.name)
            .font(.title)
            .bold()
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    let favoritesViewModel = FavoritesViewModel()
    DetailsView(breed: MockData.sampleBreed, favoritesViewModel: FavoritesViewModel())
        .modelContainer(for: CatBreed.self, inMemory: true)
        .environmentObject(favoritesViewModel)
}
