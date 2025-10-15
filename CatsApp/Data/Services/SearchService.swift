//
//  SearchService.swift
//  CatsApp
//
//  Created by Carlos Costa on 09/10/2025.
//

import Foundation

protocol SearchServiceProtocol {
    func searchBreeds(query: String, in breeds: [CatBreed]) -> [CatBreed]
}

struct SearchService: SearchServiceProtocol {
    func searchBreeds(query: String, in breeds: [CatBreed]) -> [CatBreed] {
        guard !query.isEmpty else { return breeds }
        return breeds.filter {
            $0.name.lowercased().contains(query.lowercased())
        }
    }
}
