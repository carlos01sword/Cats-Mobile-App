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
    var statusCode: Int = 200
    var error: Error?

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T where T: Decodable {
        if let error = error {
            throw error
        }
        if !(200...299).contains(statusCode) {
            throw NetworkError.serverStatus(statusCode)
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

@Suite("NetworkClient Failure Test")
struct NetworkClientErrorTests {
    
    @Test("Throws decoding error for empty data")
func testEmptyDataDecodingError() async throws { // Add a 'throws' here
    let client = MockClient()
    client.resultData = Data()
    let endpoint = Endpoint(path: "breeds")

    let thrownError = try await #expect(throws: client.request(endpoint) as [BreedsDataService.CatBreed])

    guard case .decoding = thrownError as? NetworkError else {
        #expect(false, "Expected NetworkError.decoding, but got \(thrownError)")
        return
    }
}
    @Test("Throws decoding error for malformed data")
    func testMalformedDataDecodingError() async {
        let client = MockClient()
        client.resultData = Data("not a json".utf8)
        let endpoint = Endpoint(path: "breeds")
        do {
            _ = try await client.request(endpoint) as [BreedsDataService.CatBreed]
            #expect(Bool(false), "Expected decoding error for malformed data, but got success")
        } catch {
            if let netErr = error as? NetworkError {
                if case .decoding = netErr {
                    #expect(true)
                } else {
                    #expect(Bool(false), "Expected decoding error, got \(netErr)")
                }
            } else {
                #expect(Bool(false), "Expected NetworkError but got \(type(of: error))")
            }
        }
    }
}

@Suite("NetworkClient HTTP Status Test")
struct NetworkClientStatusCodeTests {
    @Test("Throws serverStatus error for 404 response")
    func test404StatusCode() async {
        let client = MockClient()
        client.statusCode = 404
        client.resultData = Data("[]".utf8)
        let endpoint = Endpoint(path: "breeds")
        do {
            _ = try await client.request(endpoint) as [BreedsDataService.CatBreed]
            #expect(Bool(false), "Expected serverStatus error for 404, but got success")
        } catch {
            if let netErr = error as? NetworkError {
                if case .serverStatus(let code) = netErr {
                    #expect(code == 404, "Expected 404 status code, got \(code)")
                } else {
                    #expect(Bool(false), "Expected serverStatus error, got \(netErr)")
                }
            } else {
                #expect(Bool(false), "Expected NetworkError but got \(type(of: error))")
            }
        }
    }
    @Test("Throws serverStatus error for 500 response")
    func test500StatusCode() async {
        let client = MockClient()
        client.statusCode = 500
        client.resultData = Data("[]".utf8)
        let endpoint = Endpoint(path: "breeds")
        do {
            _ = try await client.request(endpoint) as [BreedsDataService.CatBreed]
            #expect(Bool(false), "Expected serverStatus error for 500, but got success")
        } catch {
            if let netErr = error as? NetworkError {
                if case .serverStatus(let code) = netErr {
                    #expect(code == 500, "Expected 500 status code, got \(code)")
                } else {
                    #expect(Bool(false), "Expected serverStatus error, got \(netErr)")
                }
            } else {
                #expect(Bool(false), "Expected NetworkError but got \(type(of: error))")
            }
        }
    }
}
