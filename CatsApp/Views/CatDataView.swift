//
//  ContentView.swift
//  CatsApp
//
//  Created by Carlos Costa on 01/08/2025.
//

import SwiftUI

struct CatDataView: View {
    
    
    @StateObject private var viewModel = CatListViewModel()

    var body: some View {
        
        NavigationView {
            List(viewModel.catBreeds) { breed in
                
                HStack(spacing: 16) {
                    if let imageUrl = breed.referenceImageUrl,
                       let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(0.2)
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
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("Cats App")
            .task {
                await viewModel.loadBreeds()
            }
            
        }
    }
}


