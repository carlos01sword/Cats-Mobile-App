//
//  NetworkClientTests.swift
//  CatsAppTests
//
//  Created by Carlos Costa on 08/10/2025.
//

import Foundation
import Testing

@testable import CatsApp

class MockClient: NetworkClientProtocol {
    var resultData: Data?
    var response: URLResponse?
    var error: Error?

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    where T: Decodable {
        if let error = error {
            throw error
        }
        guard let data = resultData else {
            throw NetworkError.unknown
        }
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}


@Suite("NetworkClient Success Test")
struct NetworkClientTests {
    @Test("Successful request decodes MockDTO")
    func testSuccess() async throws {
        
        let client = MockClient()
        let json = try JSONEncoder().encode(MockDTO.breedsDTO)
        
        client.resultData = json

        let endpoint = Endpoint(path: "breeds")
        
        let breeds: [BreedsDataService.CatBreed] = try await client.request(endpoint)
        
        #expect(!breeds.isEmpty, "Breeds should not be empty")
        #expect(breeds.count == MockDTO.breedsDTO.count, "Breeds count should match mock data")
        #expect(breeds.first?.id == "abys", "First breed should be Abyssinian")
    }
}
