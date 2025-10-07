//
//  BreedListView.swift
//  CatsApp
//
//  Created by Carlos Costa on 07/08/2025.
//

import SwiftUI

struct BreedListView<Header: View>: View {
    let breeds: [CatBreed]
    private let header: Header?
    private let onSelect: (CatBreed) -> Void
    private let onFavorite: (CatBreed) -> Void
    private let onRowAppear: (CatBreed) -> Void

    init(
        breeds: [CatBreed],
        header: Header? = nil,
        onSelect: @escaping (CatBreed) -> Void = { _ in },
        onFavorite: @escaping (CatBreed) -> Void = { _ in },
        onRowAppear: @escaping (CatBreed) -> Void = { _ in }
    ) {
        self.breeds = breeds
        self.header = header
        self.onSelect = onSelect
        self.onFavorite = onFavorite
        self.onRowAppear = onRowAppear
    }

    // Initializer for when there is no header just for convenience
    init(
        breeds: [CatBreed],
        onSelect: @escaping (CatBreed) -> Void = { _ in },
        onFavorite: @escaping (CatBreed) -> Void = { _ in },
        onRowAppear: @escaping (CatBreed) -> Void = { _ in }
    ) where Header == EmptyView {
        self.breeds = breeds
        self.header = nil
        self.onSelect = onSelect
        self.onFavorite = onFavorite
        self.onRowAppear = onRowAppear
    }

    var body: some View {
        List {
            if let header = header {
                Section { header }
                    .listRowSeparator(.hidden)
            }
            ForEach(breeds) { breed in
                BreedRowView(
                    breed: breed,
                    onFavoriteTapped: { onFavorite(breed) }
                )
                .contentShape(Rectangle())
                .onTapGesture { onSelect(breed) }
                .onAppear { onRowAppear(breed) }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    BreedListView(breeds: MockData.breeds)
}
