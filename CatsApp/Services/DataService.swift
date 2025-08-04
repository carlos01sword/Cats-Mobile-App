//
//  DataService.swift
//  CatsApp
//
//  Created by Carlos Costa on 03/08/2025.
//

import Foundation

struct CatDataService {
    
    private let apiURL = "https://api.thecatapi.com/v1/breeds"
    private let apiKey = "live_qZSunkWQL4nxKItjmfA2TcTwIolM00gM2zU489lP9X7oCLuxzHp7nSzvBAApOOY"

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

    func fetchCatsData() async -> [CatBreed] {
        guard let url = URL(string: apiURL) else { return [] }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode([CatBreed].self, from: data)
        } catch {
            print("Fetch error:", error.localizedDescription)
            return []
        }
    }
}
