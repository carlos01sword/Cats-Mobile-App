import Foundation
import SwiftData

protocol BreedsRepositoryProtocol {
    @MainActor
    func fetchPage(page: Int, limit: Int, context: ModelContext) async throws -> PageResult
    @MainActor
    func savePage(_ dtos: [BreedsDataService.CatBreed], context: ModelContext)
        async throws -> [CatBreed]
    @MainActor
    func toggleFavorite(_ breed: CatBreed, context: ModelContext) throws
    @MainActor
    func fetchFavorites(context: ModelContext) throws -> [CatBreed]
    @MainActor
    func fetchAll(context: ModelContext) throws -> [CatBreed]
}

struct PageResult {
    let breeds: [CatBreed]
    let fetchedCount: Int
}

struct BreedsRepository: BreedsRepositoryProtocol {
    private let service: BreedsFetching
    private let database: DatabaseServiceProtocol

    init(service: BreedsFetching = BreedsDataService(), database: DatabaseServiceProtocol = DatabaseService()) {
        self.service = service
        self.database = database
    }

    @MainActor
    func fetchPage(page: Int, limit: Int, context: ModelContext) async throws -> PageResult {
        do {
            let dtos = try await service.fetchCatsData(
                page: page,
                limit: limit
            )
            let count = dtos.count
            let saved = try database.saveBreeds(dtos, context: context)
            return PageResult(breeds: saved, fetchedCount: count)
        } catch let error as DomainError {
            throw error
        } catch {
            throw DomainError.networkError
        }
    }

    @MainActor
    func savePage(_ dtos: [BreedsDataService.CatBreed], context: ModelContext) async throws -> [CatBreed] {
        do {
            return try database.saveBreeds(dtos, context: context)
        } catch {
            throw error
        }
    }

    @MainActor
    func toggleFavorite(_ breed: CatBreed, context: ModelContext) throws {
        try database.toggleFavorite(breed, context: context)
    }

    @MainActor
    func fetchFavorites(context: ModelContext) throws -> [CatBreed] {
        try database.fetchFavoriteBreeds(context: context)
    }

    @MainActor
    func fetchAll(context: ModelContext) throws -> [CatBreed] {
        try database.fetchAllBreeds(context: context)
    }
}
