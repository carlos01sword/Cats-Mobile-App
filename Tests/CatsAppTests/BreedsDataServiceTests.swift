//
//  NetworkRequests.swift
//  CatsAppTests
//
//  Created by Carlos Costa on 08/10/2025.
//

import Foundation
import Testing
@testable import CatsApp

final class MockBreedsService: BreedsFetching {
    let breedsToReturn: [BreedsDataService.CatBreed]?
    let errorToThrow: NetworkError?
    
    init(breeds: [BreedsDataService.CatBreed]? = nil, error: NetworkError? = nil) {
        self.breedsToReturn = breeds
        self.errorToThrow = error
    }
    
    func fetchCatsData(page: Int, limit: Int) async throws -> [BreedsDataService.CatBreed] {
        if let error = errorToThrow {
            throw error
        }
        return Array((breedsToReturn ?? []).prefix(limit))
    }
}

final class MockNetworkClient: NetworkClientProtocol {
    let errorToThrow: NetworkError
    
    init(error: NetworkError) {
        self.errorToThrow = error
    }
    
    func request<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
        throw errorToThrow
    }
}


@Suite("BreedsDataService Success / Empty Data")
struct BreedsDataServiceTests {
    
    @Test("Fetch breeds returns data")
    func testFetchBreeds() async throws {
        let service = MockBreedsService(breeds: MockDTO.breedsDTO)
        let breeds = try await service.fetchCatsData(page: 0, limit: 10)
        
        #expect(!breeds.isEmpty, "Breeds should not be empty")
        #expect(breeds.count == 10, "Breeds count should be = limit")
        #expect(breeds.allSatisfy { !$0.name.isEmpty }, "All breeds should have a name")
        #expect(breeds.allSatisfy { !$0.origin.isEmpty }, "All breeds should have an origin")
        #expect(breeds.allSatisfy { !$0.description.isEmpty }, "All breeds should have a description")
        #expect(breeds.allSatisfy { !$0.life_span.isEmpty }, "All breeds should have a life span")
        #expect(breeds.allSatisfy { !$0.temperament.isEmpty }, "All breeds should have a temperament")
    }
    
    @Test("Fetch breeds returns empty array")
    func testFetchEmptyData() async throws {
        let service = MockBreedsService(breeds: [])
        let breeds = try await service.fetchCatsData(page: 0, limit: 10)
        #expect(breeds.isEmpty, "Breeds should be empty")
    }
}

@Suite("BreedsDataService Error Mapping")
struct BreedsDataServiceErrorTests {
    
    private func expectDomainError(for networkError: NetworkError, toMatch expected: DomainError) async {
        let client = MockNetworkClient(error: networkError)
        let service = BreedsDataService(client: client)
        await #expect(throws: expected) {
            _ = try await service.fetchCatsData(page: 0, limit: 10)
        }
    }
    
    @Test("Transport error maps to DomainError.networkError")
    func testTransportError() async {
        await expectDomainError(for: .transport(NSError(domain: "", code: 0)), toMatch: .networkError)
    }
    
    @Test("Decoding error maps to DomainError.decodingError")
    func testDecodingError() async {
        await expectDomainError(for: .decoding(NSError(domain: "", code: 0)), toMatch: .decodingError)
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
