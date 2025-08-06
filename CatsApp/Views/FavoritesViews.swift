//
//  FavoritesViews.swift
//  CatsApp
//
//  Created by Carlos Costa on 05/08/2025.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var context
    @Query(
        filter: #Predicate { (breed: CatBreed) in
            breed.isFavorite
        }
    ) private var favoriteBreeds: [CatBreed]
    
    
    func averageLifeSpan(from breeds: [CatBreed]) -> Int {
        
        guard !breeds.isEmpty else {
            return 0
        }
        
        var total: Int = 0
        var counter: Int = 0
        
        for breed in breeds {
            let values = breed.lifeSpan
                .split(separator: "-")
                .map { $0.trimmingCharacters(in: .whitespaces) }
            
            if let max = values.last,
               let maxInt = Int(max){
                total += maxInt
                counter += 1
            }
        }
        
        guard counter > 0 else {
            return 0
        }
        
        return total / counter
        
    }
    
    
    var body: some View {
        NavigationView {
            VStack() {
                if !favoriteBreeds.isEmpty {
                    let avg = averageLifeSpan(from: favoriteBreeds)
                    Text("Average lifespan: \(avg) years")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .frame(height: 36)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                        .background(RoundedRectangle(cornerRadius: 14)
                            .fill(Color(.systemGray6))
                            .shadow(color: Color(.systemGray3), radius: 2, x: 0, y: 1)
                            .padding(.horizontal)
                            .padding(.top,8)
                            )
                }
                List(favoriteBreeds) { breed in
                    NavigationLink(destination: DetailsView(breed: breed)) {
                        HStack(spacing: 16) {
                            if let imageUrl = breed.referenceImageUrl,
                               let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    Color.gray.opacity(1)
                                }
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else {
                                Color.gray.opacity(0.1)
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }

                            Text(breed.name)
                                .font(.headline)

                            Spacer()
                        }
                        .padding(.vertical, 5)
                    }
                }
                .navigationTitle("Favorites")
            }
            .background(Color(.systemGroupedBackground))
            
        }
    }
}
