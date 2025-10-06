//
//  SearchModifier.swift
//  CatsApp
//
//  Created by Carlos Costa on 01/10/2025.
//

import SwiftUI

struct BreedSearchModifier: ViewModifier {

    @Binding var text: String
    func body(content: Content) -> some View {
        content
            .searchable(
                text: $text,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: Text("Search breeds")
            )
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
    }
}

extension View {
    func breedSearchable(_ text: Binding<String>) -> some View {
        self.modifier(BreedSearchModifier(text: text))
    }
}

