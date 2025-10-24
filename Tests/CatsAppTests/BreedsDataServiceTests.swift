//
//  NetworkRequests.swift
//  CatsAppTests
//
//  Created by Carlos Costa on 08/10/2025.
//

import Foundation
import Testing

@testable import CatsApp

@Suite("BreedsDataService Success / Empty Data")
struct BreedsDataServiceTests {

    @Test("Fetch breeds returns data")
    func testFetchBreeds() async throws {
        let service = BreedsDataService(
            fetchCatsData: { page, limit in
                return Array(MockDTO.breedsDTO.prefix(limit))
            }
        )

        let breeds = try await service.fetchCatsData(0, 10)

        #expect(!breeds.isEmpty, "Breeds should not be empty")
        #expect(breeds.count == 10, "Breeds count should be = limit")
        #expect(
            breeds.allSatisfy { !$0.name.isEmpty },
            "All breeds should have a name"
        )
        #expect(
            breeds.allSatisfy { !$0.origin.isEmpty },
            "All breeds should have an origin"
        )
        #expect(
            breeds.allSatisfy { !$0.description.isEmpty },
            "All breeds should have a description"
        )
        #expect(
            breeds.allSatisfy { !$0.life_span.isEmpty },
            "All breeds should have a life span"
        )
        #expect(
            breeds.allSatisfy { !$0.temperament.isEmpty },
            "All breeds should have a temperament"
        )
    }

    @Test("Fetch breeds returns empty array")
    func testFetchEmptyData() async throws {
        let service = BreedsDataService(
            fetchCatsData: { page, limit in
                return []
            }
        )
        let breeds = try await service.fetchCatsData(0, 10)
        #expect(breeds.isEmpty, "Breeds should be empty")
    }
}

@Suite("BreedsDataService Error Mapping")
struct BreedsDataServiceErrorTests {

    private func expectDomainError(
        for networkError: NetworkError,
        toMatch expected: DomainError
    ) async {
        let mockClient = NetworkClient(
            requestData: { _ in
                throw networkError
            }
        )

        let service = BreedsDataService.live(client: mockClient)

        await #expect(throws: expected) {
            _ = try await service.fetchCatsData(0, 10)
        }
    }

    @Test("Transport error maps to DomainError.networkError")
    func testTransportError() async {
        await expectDomainError(
            for: .transport(NSError(domain: "", code: 0)),
            toMatch: .networkError
        )
    }

    @Test("Decoding error maps to DomainError.decodingError")
    func testDecodingError() async {
        await expectDomainError(
            for: .decoding(NSError(domain: "", code: 0)),
            toMatch: .decodingError
        )
    }

    @Test("Bad data maps to DomainError.decodingError")
    func testBadDataError() async {

        let mockClient = NetworkClient(
            requestData: { _ in
                return Data("bad json".utf8)
            }
        )
        let service = BreedsDataService.live(client: mockClient)

        await #expect(throws: DomainError.decodingError) {
            _ = try await service.fetchCatsData(0, 10)
        }
    }

    @Test("Unknown error maps to DomainError.unknownError")
    func testUnknownError() async {
        await expectDomainError(for: .unknown, toMatch: .unknownError)
    }

    @Test("Invalid request maps to DomainError.networkError")
    func testInvalidRequestError() async {
        await expectDomainError(for: .invalidRequest, toMatch: .networkError)
    }

    @Test("Server status error maps to DomainError.networkError")
    func testServerStatusError() async {
        await expectDomainError(for: .serverStatus(500), toMatch: .networkError)
    }
}
