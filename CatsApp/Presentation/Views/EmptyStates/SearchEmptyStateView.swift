//
//  SearchEmptyStateView.swift
//  CatsApp
//
//  Created by Carlos Costa on 01/10/2025.
//

import SwiftUI

struct SearchEmptyStateView: View {
    let searchText: String
    var body: some View {
        VStack(spacing: ConstantsUI.defaultVerticalSpacing) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: ConstantsUI.emptyStateIconSize))
                .foregroundStyle(.secondary)
            Text("No results for \"\(searchText)\"")
                .font(.headline)
                .foregroundStyle(.primary)
            Text("Try a different name")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
        .padding(ConstantsUI.largeVerticalSpacing)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    SearchEmptyStateView(searchText: "abc")
        .padding()
}
