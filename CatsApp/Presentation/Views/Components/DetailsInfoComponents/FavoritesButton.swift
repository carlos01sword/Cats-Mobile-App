//  FavoritesButton.swift
//  CatsApp
//
//  Created by Carlos Costa on 09/10/2025.
//

import SwiftUI

struct FavoritesButton: View {

    @StateObject var viewModel: DetailsViewModel
    @Environment(\.modelContext) private var context

    var body: some View {
        Button {
            viewModel.toggleFavorite(context: context)
        } label: {
            Text(viewModel.favoriteButtonLabel(context: context))
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                .frame(minWidth: ConstantsUI.favoritesButtonMinWidth)
                .background(
                    RoundedRectangle(
                        cornerRadius: ConstantsUI.favoritesButtonCornerRadius
                    )
                    .fill(viewModel.favoriteButtonColor(context: context))
                    .shadow()
                )
        }
        .padding(.vertical, ConstantsUI.favoritesButtonVerticalPadding)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
    }
}
