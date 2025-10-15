//
//  FavoritesEmptyStateView.swift
//  CatsApp
//
//  Created by Carlos Costa on 01/10/2025.
//

import SwiftUI

struct FavoritesEmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "star")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("No favorites yet")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Tap the star on a breed to add it here.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    FavoritesEmptyStateView()
}
