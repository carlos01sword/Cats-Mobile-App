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

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    where T: Decodable {
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
        let apiService = BreedsDataService.live(client: client)
        let breeds: [CatBreedDTO] = try await apiService.fetchCatsData(0, MockDTO.breedsDTO.count)
        #expect(!breeds.isEmpty, "Breeds should not be empty")
        #expect(
            breeds.count == MockDTO.breedsDTO.count,
            "Breeds count should match mock data"
        )
        #expect(breeds.first?.id == "abys", "First breed should be Abyssinian")
    }
}

@Suite("NetworkClient Failure Test")
struct NetworkClientErrorTests {

    @Test("Throws decoding error for empty data")
    func testEmptyDataDecodingError() async {
        let client = MockClient()
        client.resultData = Data()
        let apiService = BreedsDataService.live(client: client)
        do {
            _ = try await apiService.fetchCatsData(0, 10)
            #expect(
                Bool(false),
                "Expected decoding error for empty data, but got success"
            )
        } catch let domainError as DomainError {
            if case .decodingError = domainError {
                #expect(true)
            } else {
                #expect(
                    Bool(false),
                    "Expected DomainError.decodingError, got \(domainError)"
                )
            }
        } catch {
            #expect(
                Bool(false),
                "Expected DomainError but got \(type(of: error))"
            )
        }
    }

    @Test("Throws decoding error for malformed data")
    func testMalformedDataDecodingError() async {
        let client = MockClient()
        client.resultData = Data("not a json".utf8)
        let apiService = BreedsDataService.live(client: client)
        do {
            _ = try await apiService.fetchCatsData(0, 10)
            #expect(
                Bool(false),
                "Expected decoding error for malformed data, but got success"
            )
        } catch let domainError as DomainError {
            if case .decodingError = domainError {
                #expect(true)
            } else {
                #expect(
                    Bool(false),
                    "Expected DomainError.decodingError, got \(domainError)"
                )
            }
        } catch {
            #expect(
                Bool(false),
                "Expected DomainError but got \(type(of: error))"
            )
        }
    }
}

@Suite("NetworkClient HTTP Status Tests")
struct NetworkClientStatusCodeTests {

    func runStatusCodeTest(_ code: Int) async {
        let client = MockClient()
        client.statusCode = code
        client.resultData = Data("[]".utf8)
        let apiService = BreedsDataService.live(client: client)
        do {
            _ = try await apiService.fetchCatsData(0, 10)
            #expect(
                Bool(false),
                "Expected serverStatus error for \(code), but got success"
            )
        } catch let domainError as DomainError {
            if case .networkError = domainError {
                #expect(true)
            } else {
                #expect(
                    Bool(false),
                    "Expected DomainError.networkError, got \(domainError)"
                )
            }
        } catch {
            #expect(
                Bool(false),
                "Expected DomainError but got \(type(of: error))"
            )
        }
    }

    @Test("Throws serverStatus error for 404 response")
    func test404StatusCode() async {
        await runStatusCodeTest(404)
    }

    @Test("Throws serverStatus error for 500 response")
    func test500StatusCode() async {
        await runStatusCodeTest(500)
    }
}
