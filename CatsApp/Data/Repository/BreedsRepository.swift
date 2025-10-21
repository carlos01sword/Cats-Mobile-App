import Foundation
import SwiftData

struct PageResult {
    let breeds: [CatBreed]
    let fetchedCount: Int
}

struct BreedsRepository {
    public internal(set) var fetchPage:
        @MainActor (Int, Int, ModelContext) async throws -> PageResult
    public internal(set) var savePage:
        @MainActor ([CatBreedDTO], ModelContext) async throws -> [CatBreed]
    public internal(set) var toggleFavorite:
        @MainActor (CatBreed, ModelContext) throws -> Void
    public internal(set) var fetchFavorites:
        @MainActor (ModelContext) throws -> [CatBreed]
    public internal(set) var fetchAll:
        @MainActor (ModelContext) throws -> [CatBreed]
    public internal(set) var cacheImage:
        @MainActor (String, String, ModelContext) async throws -> Void

    static func live(
        service: BreedsDataService = BreedsDataService.live(),
        database: DatabaseService = DatabaseService.live()
    ) -> BreedsRepository {
        BreedsRepository(
            fetchPage: { page, limit, context in
                do {
                    let dtos = try await service.fetchCatsData(
                        page,
                        limit
                    )
                    let count = dtos.count
                    let saved = try database.saveBreeds(dtos, context)
                    return PageResult(breeds: saved, fetchedCount: count)
                } catch let error as DomainError {
                    throw error
                } catch {
                    throw DomainError.networkError
                }
            },
            savePage: { dtos, context in
                do {
                    return try database.saveBreeds(dtos, context)
                } catch {
                    throw error
                }
            },
            toggleFavorite: { breed, context in
                try database.toggleFavorite(breed, context)
            },
            fetchFavorites: { context in
                try database.fetchFavoriteBreeds(context)
            },
            fetchAll: { context in
                try database.fetchAllBreeds(context)
            },
            cacheImage: { breedId, urlString, context in
                do {
                    try await database.cacheImage(
                        breedId,
                        urlString,
                        context
                    )
                } catch {
                    throw DomainError.customError(
                        "Failed to cache image: \(error.localizedDescription)"
                    )
                }
            }
        )
    }
}
