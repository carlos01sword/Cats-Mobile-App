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

    init(service: BreedsFetching = BreedsDataService()) {
        self.service = service
    }

    @MainActor
    func fetchPage(page: Int, limit: Int, context: ModelContext) async throws -> PageResult {
        do {
            let dtos = try await service.fetchCatsData(
                page: page,
                limit: limit
            )
            let count = dtos.count
            let saved = try await savePage(dtos, context: context)
            return PageResult(breeds: saved, fetchedCount: count)
        } catch let error as DomainError {
            throw error
        } catch {
            throw DomainError.networkError
        }
    }

    @MainActor
    func savePage(_ dtos: [BreedsDataService.CatBreed], context: ModelContext)
        async throws -> [CatBreed]
    {
        guard !dtos.isEmpty else { return try fetchAll(context: context) }

        let existingDescriptor = FetchDescriptor<CatBreed>()
        
        let existing: [CatBreed]
        do {
            existing = try context.fetch(existingDescriptor)
        } catch {
            throw DomainError.persistenceError
        }
        
        var existingIds = Set(existing.map { $0.id })

        var inserted = false
        for dto in dtos {
            if existingIds.contains(dto.id) { continue }
            let model = CatBreed(
                id: dto.id,
                name: dto.name,
                origin: dto.origin,
                temperament: dto.temperament,
                breedDescription: dto.description,
                lifeSpan: dto.life_span,
                referenceImageId: dto.reference_image_id,
                isFavorite: false
            )
            context.insert(model)
            existingIds.insert(dto.id)
            inserted = true
        }
        if inserted {
            do {
                try context.save()
            } catch {
                throw DomainError.persistenceError
            }
        }

        do{
            let all = try context.fetch(existingDescriptor)
            return CatBreed.sortedByName(all)
        } catch {
            throw DomainError.persistenceError
        }
    }

    @MainActor
    func toggleFavorite(_ breed: CatBreed, context: ModelContext) throws {
        breed.isFavorite.toggle()
        do {
            try context.save()
        } catch {
            throw DomainError.persistenceError
        }
         
    }

    @MainActor
    func fetchFavorites(context: ModelContext) throws -> [CatBreed] {
        let predicate = #Predicate<CatBreed> { $0.isFavorite == true }
        let descriptor = FetchDescriptor<CatBreed>(predicate: predicate)
        
        do {
            let favorites = try context.fetch(descriptor)
            return CatBreed.sortedByName(favorites)
        } catch {
            throw DomainError.persistenceError
        }
    }

    @MainActor
    func fetchAll(context: ModelContext) throws -> [CatBreed] {
        let descriptor = FetchDescriptor<CatBreed>()
        do{
            let all = try context.fetch(descriptor)
            return CatBreed.sortedByName(all)
        } catch{
            throw DomainError.persistenceError
        }
    }
}
