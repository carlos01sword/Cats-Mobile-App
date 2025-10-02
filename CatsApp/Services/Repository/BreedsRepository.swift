import Foundation
import SwiftData

protocol BreedsRepositoryProtocol {
    @MainActor
    func fetchPage(page: Int, limit: Int, context: ModelContext) async -> Result<PageResult, Error>
    @MainActor
    func savePage(_ dtos: [BreedsDataService.CatBreed], context: ModelContext) async throws -> [CatBreed]
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
    func fetchPage(page: Int, limit: Int, context: ModelContext) async -> Result<PageResult, Error> {
        let networkResult = await service.fetchCatsData(page: page, limit: limit)
        switch networkResult {
        case .success(let dtos):
            let count = dtos.count
            do {
                let saved = try await savePage(dtos, context: context)
                return .success(PageResult(breeds: saved, fetchedCount: count))
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    @MainActor
    func savePage(_ dtos: [BreedsDataService.CatBreed], context: ModelContext) async throws -> [CatBreed] {
        guard !dtos.isEmpty else { return try fetchAll(context: context) }

        let existingDescriptor = FetchDescriptor<CatBreed>()
        let existing = (try? context.fetch(existingDescriptor)) ?? []
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
        if inserted { try? context.save() }

        let all = (try? context.fetch(existingDescriptor)) ?? []
        return all.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    @MainActor
    func toggleFavorite(_ breed: CatBreed, context: ModelContext) throws {
        breed.isFavorite.toggle()
        try? context.save()
    }

    @MainActor
    func fetchFavorites(context: ModelContext) throws -> [CatBreed] {
        let predicate = #Predicate<CatBreed> { $0.isFavorite == true }
        let descriptor = FetchDescriptor<CatBreed>(predicate: predicate)
        let favorites = try context.fetch(descriptor)
        return favorites.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    @MainActor
    func fetchAll(context: ModelContext) throws -> [CatBreed] {
        let descriptor = FetchDescriptor<CatBreed>()
        let all = try context.fetch(descriptor)
        return all.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
