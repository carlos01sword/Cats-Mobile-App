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
    var isLoading: Bool
    let isEndReached: Bool

    init(
        breeds: [CatBreed],
        header: Header? = nil,
        onSelect: @escaping (CatBreed) -> Void = { _ in },
        onFavorite: @escaping (CatBreed) -> Void = { _ in },
        onRowAppear: @escaping (CatBreed) -> Void = { _ in },
        isLoading: Bool = false,
        isEndReached: Bool = false
    ) {
        self.breeds = breeds
        self.header = header
        self.onSelect = onSelect
        self.onFavorite = onFavorite
        self.onRowAppear = onRowAppear
        self.isLoading = isLoading
        self.isEndReached = isEndReached
    }

    // Initializer for when there is no header just for convenience
    init(
        breeds: [CatBreed],
        onSelect: @escaping (CatBreed) -> Void = { _ in },
        onFavorite: @escaping (CatBreed) -> Void = { _ in },
        onRowAppear: @escaping (CatBreed) -> Void = { _ in },
        isLoading: Bool = false,
        isEndReached: Bool = false
    ) where Header == EmptyView {
        self.breeds = breeds
        self.header = nil
        self.onSelect = onSelect
        self.onFavorite = onFavorite
        self.onRowAppear = onRowAppear
        self.isLoading = isLoading
        self.isEndReached = isEndReached
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: .zero) {
                if let header = header {
                    Section { header }
                }

                ForEach(breeds) { breed in
                    BreedRowView(
                        breed: breed,
                        onFavoriteTapped: { onFavorite(breed) }
                    )
                    .contentShape(Rectangle())
                    .onTapGesture { onSelect(breed) }
                    .onAppear { onRowAppear(breed) }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }

                if isEndReached {
                    endReachedView
                }

                if isLoading {
                    loadingView
                }
            }
        }
    }

    private var loadingView: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.2)
                .padding(12)
            Spacer()
        }
    }

    private var endReachedView: some View {
        HStack {
            Spacer()
            Text("No more breeds to load")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding()
            Spacer()
        }
        .listRowSeparator(.hidden)
    }

}

#Preview {
    BreedListView(breeds: MockData.breeds)
}
