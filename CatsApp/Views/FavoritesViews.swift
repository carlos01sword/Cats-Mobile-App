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
    @State private var favoriteBreeds: [CatBreed] = []

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    if !favoriteBreeds.isEmpty {
                        let avg = Average.averageLifeSpan(from: favoriteBreeds)
                        Text("Average lifespan: \(avg) years")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                            .frame(height: 36)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(.systemGray6))
                                    .shadow(color: Color(.systemGray3), radius: 2, x: 0, y: 1)
                                    .padding(.horizontal)
                            )
                    }

                    ForEach(favoriteBreeds) { breed in
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
                                    .foregroundColor(.primary)

                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: Color(.systemGray3), radius: 4, x: 0, y: 2)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Favorites")
            .onAppear {
                loadFavorites()
            }
            .task {
                loadFavorites()
            }
            .background(Color(.systemBackground))
        }
    }
    
    func loadFavorites() {
            let descriptor = FetchDescriptor<CatBreed>(
                predicate: #Predicate { $0.isFavorite }
            )
            if let fetched = try? context.fetch(descriptor) {
                favoriteBreeds = fetched
            }
        }
}
