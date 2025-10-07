//
//  DataService.swift
//  CatsApp
//
//  Created by Carlos Costa on 03/08/2025.
//

import Foundation

protocol BreedsFetching {
    func fetchCatsData(page: Int, limit: Int) async throws -> [BreedsDataService.CatBreed]
}

struct BreedsDataService: BreedsFetching {
    
    private let client: NetworkClientProtocol
    
    init(client: NetworkClientProtocol = NetworkClient()) {
        self.client = client
    }
    
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
    
    func fetchCatsData(page: Int = 0, limit: Int = 10) async throws -> [CatBreed] {
        let endpoint = Endpoint(
            path: "breeds",
            queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit))
            ]
        )
        do {
            let breeds: [CatBreed] = try await client.request(endpoint)
            return breeds
        } catch {
            throw error
        }
    }
}
