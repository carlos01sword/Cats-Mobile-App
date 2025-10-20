//
//  NetworkClientTests.swift
//  CatsAppTests
//
//  Created by Carlos Costa on 08/10/2025.
//

import Foundation
import Testing

@testable import CatsApp


@Suite("NetworkClient Success Test")
struct NetworkClientTests {
    @Test("Successful request decodes MockDTO")
    func testSuccess() async throws {
        
        let jsonData = try JSONEncoder().encode(MockDTO.breedsDTO)

        let client = NetworkClient(
            requestData: { _ in
                return jsonData
            }
        )

        let apiService = BreedsDataService.live(client: client)
        let breeds: [CatBreedDTO] = try await apiService.fetchCatsData(
            0,
            MockDTO.breedsDTO.count
        )

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
        let client = NetworkClient(
            requestData: { _ in
                return Data()
            }
        )

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
        let client = NetworkClient(
            requestData: { _ in
                return Data("not a json".utf8)
            }
        )

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
        let client = NetworkClient(
            requestData: { _ in
                throw NetworkError.serverStatus(code)
            }
        )

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
