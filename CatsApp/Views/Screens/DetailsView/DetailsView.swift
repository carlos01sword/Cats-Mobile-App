//
//  DetailsView.swift
//  CatsApp
//
//  Created by Carlos Costa on 05/08/2025.
//

import SwiftUI
import SwiftData

struct DetailsView: View {
    
    @Environment(\.modelContext) private var context
    @Bindable var breed: CatBreed
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Spacer(minLength: 32)
                    
                    Text(breed.name)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)

                    VStack(alignment: .leading, spacing: 24) {
                        Text("Origin:")
                            .font(.headline)
                        Text(breed.origin)
                            .font(.body)
                        Text("Temperament:")
                            .font(.headline)
                        Text(breed.temperament)
                            .font(.body)
                        Text("Description:")
                            .font(.headline)
                        Text(breed.breedDescription)
                            .font(.body)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color(.secondarySystemBackground))
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
                    .padding(.horizontal)

                    Spacer(minLength: 32)
                }
                .padding()
            }

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
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
        }
    }
}
