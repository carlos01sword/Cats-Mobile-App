//
//  BreedListView.swift
//  CatsApp
//
//  Created by Carlos Costa on 07/08/2025.
//

import SwiftUI

struct BreedListView<Header: View>: View {
    let breeds: [CatBreed]
    let header: Header?
    let rowContent: (CatBreed) -> AnyView

    init(
        breeds: [CatBreed],
        header: Header? = nil,
        rowContent: @escaping (CatBreed) -> AnyView
    ) {
        self.breeds = breeds
        self.header = header
        self.rowContent = rowContent
    }

    var body: some View {
        List {
            if let header = header {
                Section {
                    header
                }
                .listRowSeparator(.hidden)
            }

            ForEach(breeds) { breed in
                rowContent(breed)
                    .listRowSeparator(.hidden)
                    
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    BreedListView(breeds: MockData.breeds, header: EmptyView()) { breed in
        AnyView(
            BreedRowView(breed: breed) {}
        )
    }
}
