//
//  BreedsRepositoryTests.swift
//  CatsAppTests
//
//  Created by Carlos Costa on 08/10/2025.
//

import Foundation
import SwiftData
import Testing

@testable import CatsApp

@MainActor
@Suite("BreedsRepositoryTests")
struct BreedsRepositoryTests {
    @MainActor
    private func fetchBreeds(page: Int, limit: Int) async throws -> Int {
        let repository = BreedsRepository(service: BreedsDataService())
        let container = try ModelContainer(
            for: CatBreed.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )
        let context = ModelContext(container)
        let result = try await repository.fetchPage(
            page: page,
            limit: limit,
            context: context
        )
        return result.breeds.count
    }

    @Test("Fetch breeds with various limits")
    func testFetchBreedsWithLimits() async throws {
        let limits = [1, 5, 10, 15]
        let page = 0
        for limit in limits {
            let count = try await fetchBreeds(page: page, limit: limit)
            #expect(count == limit, "Should fetch only \(limit) breeds, got \(count)")
        }
    }

    @MainActor
    @Test("Pagination without overlapping breeds")
    func testPaginationWithoutOverlappingBreeds() async throws {
        let limit = 10
        let pages = [0, 1, 2,3,4,5,6,7] // page 6 returns fewer than 10 breeds
        // and page 7 returns 0 breeds as there are only 67 breeds in total so it is expected
        var allIds = Set<String>()
        let repository = BreedsRepository(service: BreedsDataService())
        let container = try ModelContainer(
            for: CatBreed.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )
        let context = ModelContext(container)
        for page in pages {
            let result = try await repository.fetchPage(
                page: page,
                limit: limit,
                context: context
            )
            let newBreeds = Set(result.breeds.map { $0.id }).subtracting(allIds)
            
            print("\n--- Page \(page) ---")
            print("Total breeds returned: \(result.breeds.count)")
            print("New breeds this page (\(newBreeds.count)):", newBreeds.sorted())
            print("\n--- Total ---")
            print("All breeds so far:", allIds.union(newBreeds).sorted())
            
            #expect(newBreeds.count <= limit,"Page \(page) should fetch \(limit) new breeds, got \(newBreeds.count)")
            let intersection = allIds.intersection(newBreeds)
            #expect(intersection.isEmpty,"Page \(page) breeds should not overlap with previous pages")
            allIds.formUnion(newBreeds)
        }
    }
}
