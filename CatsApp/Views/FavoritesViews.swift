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
        NavigationStack {
            VStack(spacing: 12) {
                if !favoriteBreeds.isEmpty {
                    let avg = averageLifeSpan(from: favoriteBreeds)
                    Text("Average lifespan: \(avg) years")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }

                    List(favoriteBreeds) { breed in
                        NavigationLink(destination: DetailsView()) {
                            HStack(spacing: 16) {
                                if let urlString = breed.referenceImageUrl,
                                   let url = URL(string: urlString) {
                                    AsyncImage(url: url) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Color.gray.opacity(0.1)
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
                        .listStyle(.plain)
                }
                .navigationTitle("Favorites")
            }
        }
    }
