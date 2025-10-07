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
                    Text(viewModel.name)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Origin:")
                            .font(.headline)
                        Text(viewModel.origin)
                            .font(.body)
                        Text("Temperament:")
                            .font(.headline)
                        Text(viewModel.temperament)
                            .font(.body)
                        Text("Description:")
                            .font(.headline)
                        Text(viewModel.breedDescription)
                            .font(.body)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color(.secondarySystemBackground))
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
                    .padding(.horizontal)
                    Spacer(minLength: 32)
                }
                .padding()
            }
            Button {
                viewModel.toggleFavorite(context: context)
            } label: {
                Text(viewModel.favoriteButtonLabel)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(minWidth: 220)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(viewModel.favoriteButtonColor)
                            .shadow(color: Color(.systemGray3), radius: 2, x: 0, y: 2)
                    )
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    let favoritesViewModel = FavoritesViewModel()
    DetailsView(breed: MockData.sampleBreed, favoritesViewModel: FavoritesViewModel())
        .modelContainer(for: CatBreed.self, inMemory: true)
        .environmentObject(favoritesViewModel)
}
