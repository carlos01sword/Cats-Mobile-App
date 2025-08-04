//
//  CatDataViewModel.swift
//  CatsApp
//
//  Created by Carlos Costa on 03/08/2025.
//

import Foundation
import SwiftData

@MainActor
final class CatListViewModel: ObservableObject {
    @Published var catBreeds: [CatBreed] = []
    @Published var searchText: String = ""

    var filteredBreeds: [CatBreed] {
        if searchText.isEmpty {
            return catBreeds
        } else {
            return catBreeds.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    func loadBreeds(context: ModelContext) async {
        if let storedBreeds = try? context.fetch(FetchDescriptor<CatBreed>()), !storedBreeds.isEmpty {
                    catBreeds = storedBreeds
                    return
                }
        
        let fetched = await CatDataService().fetchCatsData()
        for data in fetched {
            let cat = CatBreed(
                id: data.id,
                name: data.name,
                origin: data.origin,
                temperament: data.temperament,
                breedDescription: data.description,
                lifeSpan: data.life_span,
                referenceImageId: data.reference_image_id
            )
            context.insert(cat)
        }

        try? context.save()
        if let breeds = try? context.fetch(FetchDescriptor<CatBreed>()) {
            self.catBreeds = breeds
        }
    }

    func toggleFavorite(for breed: CatBreed, context: ModelContext) {
        if let index = catBreeds.firstIndex(where: { $0.id == breed.id }) {
            catBreeds[index].isFavorite.toggle()
            try? context.save()
        }
    }
}
