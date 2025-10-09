//  FavoritesButton.swift
//  CatsApp
//
//  Created by Carlos Costa on 09/10/2025.
//

import SwiftUI

struct FavoritesButton : View{
    
    @StateObject var viewModel: DetailsViewModel
    @Environment(\.modelContext) private var context
    
    var body: some View {
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
