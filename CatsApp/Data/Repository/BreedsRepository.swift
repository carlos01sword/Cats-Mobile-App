import Foundation
import SwiftData

struct PageResult {
    let breeds: [CatBreed]
    let fetchedCount: Int
}

struct BreedsRepository {
    var fetchPage:
        @MainActor (Int, Int, ModelContext) async throws -> PageResult
    var savePage:
        @MainActor ([BreedsDataService.CatBreed], ModelContext) async throws ->
            [CatBreed]
    var toggleFavorite: @MainActor (CatBreed, ModelContext) throws -> Void
    var fetchFavorites: @MainActor (ModelContext) throws -> [CatBreed]
    var fetchAll: @MainActor (ModelContext) throws -> [CatBreed]
    var cacheImage:
        @MainActor (String, String, ModelContext) async throws -> Void

    static func live(
        service: BreedsFetching = BreedsDataService(),
        database: DatabaseServiceProtocol = DatabaseService()
    ) -> BreedsRepository {
        BreedsRepository(
            fetchPage: { page, limit, context in
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
            },
            savePage: { dtos, context in
                do {
                    return try database.saveBreeds(dtos, context: context)
                } catch {
                    throw error
                }
            },
            toggleFavorite: { breed, context in
                try database.toggleFavorite(breed, context: context)
            },
            fetchFavorites: { context in
                try database.fetchFavoriteBreeds(context: context)
            },
            fetchAll: { context in
                try database.fetchAllBreeds(context: context)
            },
            cacheImage: { breedId, urlString, context in
                do {
                    try await database.cacheImage(
                        forBreedId: breedId,
                        withUrl: urlString,
                        context: context
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
