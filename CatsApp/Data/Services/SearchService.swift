//
//  SearchService.swift
//  CatsApp
//
//  Created by Carlos Costa on 09/10/2025.
//

import Foundation

struct SearchService {
    public internal(set) var searchBreeds: (String, [CatBreed]) -> [CatBreed]
}

extension SearchService {
    static let live = SearchService { query, breeds in
        guard !query.isEmpty else { return breeds }
        return breeds.filter {
            $0.name.lowercased().contains(query.lowercased())
        }
    }
}
