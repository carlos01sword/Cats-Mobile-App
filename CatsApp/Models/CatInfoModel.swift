//
//  CatInfoModel.swift
//  CatsApp
//
//  Created by Carlos Costa on 03/08/2025.
//

import Foundation

struct CatBreed: Identifiable, Decodable {
    let id: String
    let name: String
    let origin: String
    let temperament: String
    let description: String
    let lifeSpan: String
    let image: BreedImage?
    let referenceImageId: String?


    enum CodingKeys: String, CodingKey {
        case id
        case name
        case origin
        case temperament
        case description
        case lifeSpan = "life_span"
        case image
        case referenceImageId = "reference_image_id"
    }

    struct BreedImage: Decodable {
        let url: String
    }
}

extension CatBreed {
    var referenceImageUrl: String? {
        guard let id = referenceImageId else { return nil }
        return "https://cdn2.thecatapi.com/images/\(id).jpg"
    }
}
