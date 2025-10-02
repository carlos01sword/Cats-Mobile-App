//
//  CatInfoModel.swift
//  CatsApp
//
//  Created by Carlos Costa on 03/08/2025.
//

import Foundation
import SwiftData

@Model
class CatBreed: Identifiable {
    @Attribute(.unique) var id: String
    var name: String
    var origin: String
    var temperament: String
    var breedDescription: String
    var lifeSpan: String
    var referenceImageId: String?
    var isFavorite: Bool

    init(
        id: String,
        name: String,
        origin: String,
        temperament: String,
        breedDescription: String,
        lifeSpan: String,
        referenceImageId: String? = nil,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.name = name
        self.origin = origin
        self.temperament = temperament
        self.breedDescription = breedDescription
        self.lifeSpan = lifeSpan
        self.referenceImageId = referenceImageId
        self.isFavorite = isFavorite
    }

    var referenceImageUrl: String? {
        guard let id = referenceImageId else { return nil }
        return "https://cdn2.thecatapi.com/images/\(id).jpg"
    }
}

