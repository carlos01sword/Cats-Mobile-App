//
//  DetailsView.swift
//  CatsApp
//
//  Created by Carlos Costa on 05/08/2025.
//

import SwiftUI
import SwiftData

import SwiftUI

struct DetailsView: View {
    
    @Environment(\.modelContext) private var context
    @Bindable var breed: CatBreed
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(breed.name)
                .font(.title)
                .bold()

            Text("Origin: \(breed.origin)")
                .font(.subheadline)

            Text("Temperament: \(breed.temperament)")
                .font(.subheadline)

            Text("Description:")
                .font(.headline)

            Text(breed.breedDescription)
                .font(.body)

            Spacer()
            
            Button {
                breed.isFavorite.toggle()
                try? context.save()
            } label: {
                Text(breed.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                    .foregroundColor(breed.isFavorite ? .red : .blue)
                    .padding()
                    .cornerRadius(10)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
       .padding()
   }
}
