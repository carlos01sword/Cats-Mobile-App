//
//  DataService.swift
//  CatsApp
//
//  Created by Carlos Costa on 03/08/2025.
//

import Foundation

struct BreedsDataService {
    public internal(set) var fetchCatsData: (Int, Int) async throws -> [CatBreedDTO]
}

extension BreedsDataService {
    static func live(client: NetworkClient = NetworkClient.live()) -> BreedsDataService {
        BreedsDataService(
            fetchCatsData: { page, limit in
                let endpoint = Endpoint(
                    path: "breeds",
                    queryItems: [
                        URLQueryItem(name: "page", value: String(page)),
                        URLQueryItem(name: "limit", value: String(limit)),
                    ]
                )
                do {
                    let data = try await client.requestData(endpoint)
                    do {
                        let breeds = try JSONDecoder().decode([CatBreedDTO].self, from: data)
                        return breeds
                    } catch {
                        throw NetworkError.decoding(error)
                    }
                } catch let networkError as NetworkError {
                    switch networkError {
                    case .invalidRequest, .serverStatus, .transport:
                        throw DomainError.networkError
                    case .decoding:
                        throw DomainError.decodingError
                    case .unknown:
                        throw DomainError.unknownError
                    }
                } catch {
                    throw DomainError.unknownError
                }
            }
        )
    }
}
