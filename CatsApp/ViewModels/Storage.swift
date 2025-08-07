//
//  Storage.swift
//  CatsApp
//
//  Created by Carlos Costa on 07/08/2025.
//

import SwiftData

extension CatListViewModel {
    
    func storeBreeds(_ apiBreeds: [CatDataService.CatBreed], in context: ModelContext) async {
        var insertedNewBreeds = false
        
        for apiBreed in apiBreeds {
            if breedExists(with: apiBreed.id, in: context) {
                continue
            }
            
            let breed = CatBreed(
                id: apiBreed.id,
                name: apiBreed.name,
                origin: apiBreed.origin,
                temperament: apiBreed.temperament,
                breedDescription: apiBreed.description,
                lifeSpan: apiBreed.life_span,
                referenceImageId: apiBreed.reference_image_id,
                isFavorite: false
            )

            context.insert(breed)
            insertedNewBreeds = true
        }

        if insertedNewBreeds {
            try? context.save()
        }
        
        await refreshBreeds(from: context)
    }
}
