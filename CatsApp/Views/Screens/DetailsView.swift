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
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(minWidth: 220)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(breed.isFavorite ? Color.red : Color.blue)
                            .shadow(color: Color(.systemGray3), radius: 2, x: 0, y: 2)
                    )
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .center)
            
        }
       .padding()
   }
}
