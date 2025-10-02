//
//  DataService.swift
//  CatsApp
//
//  Created by Carlos Costa on 03/08/2025.
//

import Foundation

protocol BreedsFetching {
    func fetchCatsData(page: Int, limit: Int) async -> Result<[BreedsDataService.CatBreed], Error>
}

struct BreedsDataService: BreedsFetching {
    
    private let apiURL = "https://api.thecatapi.com/v1/breeds"
    let apiKey = SecretsDecoder.breedsApiKey
    struct CatBreed: Decodable {
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

    func fetchCatsData(page: Int = 0, limit: Int = 10) async -> Result<[CatBreed], Error> {
        var comps = URLComponents(string: apiURL)
        comps?.queryItems = [
          URLQueryItem(name: "page", value: "\(page)"),
          URLQueryItem(name: "limit", value: "\(limit)")
        ]
        guard let url = comps?.url else {
            return .failure(URLError(.badURL))
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode([CatBreed].self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
}
