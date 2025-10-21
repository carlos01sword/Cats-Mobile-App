//
//  CatBreedDTO.swift
//  CatsApp
//
//  Created by Carlos Costa on 21/10/2025.
//

import Foundation

struct CatBreedDTO: Codable {
    let id: String
    let name: String
    let origin: String
    let temperament: String
    let description: String
    let life_span: String
    let reference_image_id: String?

    private enum CodingKeys: String, CodingKey {
        case id, name, origin, temperament, description
        case life_span = "life_span"
        case reference_image_id = "reference_image_id"
    }
}

extension CatBreedDTO {
    func toModel() -> CatBreed {
        return CatBreed(
            id: self.id,
            name: self.name,
            origin: self.origin,
            temperament: self.temperament,
            breedDescription: self.description,
            lifeSpan: self.life_span,
            referenceImageId: self.reference_image_id,
            isFavorite: false
        )
    }
}
