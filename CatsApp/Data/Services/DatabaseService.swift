//
//  BreedsDataService.swift
//  CatsApp
//
//  Created by Carlos Costa on 10/10/2025.
//
import Foundation
import SwiftData

struct DatabaseService {
    var saveBreeds: @MainActor ([BreedsDataService.CatBreed], ModelContext) throws -> [CatBreed]
    var fetchAllBreeds: @MainActor (ModelContext) throws -> [CatBreed]
    var fetchFavoriteBreeds: @MainActor (ModelContext) throws -> [CatBreed]
    var toggleFavorite: @MainActor (CatBreed, ModelContext) throws -> Void
    var cacheImage: @MainActor (String, String, ModelContext) async throws -> Void
}

extension DatabaseService {
    static func live() -> DatabaseService {
        DatabaseService(
            saveBreeds: { dtos, context in
                guard !dtos.isEmpty else {
                    let descriptor = FetchDescriptor<CatBreed>()
                    do {
                        let all = try context.fetch(descriptor)
                        return CatBreed.sortedByName(all)
                    } catch {
                        throw DomainError.persistenceError
                    }
                }
                let existingDescriptor = FetchDescriptor<CatBreed>()
                let existing: [CatBreed]
                do {
                    existing = try context.fetch(existingDescriptor)
                } catch {
                    throw DomainError.persistenceError
                }
                let existingIds = Set(existing.map { $0.id })
                let newModels = dtos.compactMap { dto -> CatBreed? in
                    guard !existingIds.contains(dto.id) else {
                        return nil
                    }
                    return CatBreed(
                        id: dto.id,
                        name: dto.name,
                        origin: dto.origin,
                        temperament: dto.temperament,
                        breedDescription: dto.description,
                        lifeSpan: dto.life_span,
                        referenceImageId: dto.reference_image_id,
                        isFavorite: false
                    )
                }
                if !newModels.isEmpty {
                    newModels.forEach { context.insert($0) }
                    do {
                        try context.save()
                    } catch {
                        throw DomainError.persistenceError
                    }
                }
                do {
                    let all = try context.fetch(existingDescriptor)
                    return CatBreed.sortedByName(all)
                } catch {
                    throw DomainError.persistenceError
                }
            },
            fetchAllBreeds: { context in
                let descriptor = FetchDescriptor<CatBreed>()
                do {
                    let all = try context.fetch(descriptor)
                    return CatBreed.sortedByName(all)
                } catch {
                    throw DomainError.persistenceError
                }
            },
            fetchFavoriteBreeds: { context in
                let predicate = #Predicate<CatBreed> { $0.isFavorite == true }
                let descriptor = FetchDescriptor<CatBreed>(predicate: predicate)
                do {
                    let favorites = try context.fetch(descriptor)
                    return CatBreed.sortedByName(favorites)
                } catch {
                    throw DomainError.persistenceError
                }
            },
            toggleFavorite: { breed, context in
                breed.isFavorite.toggle()
                do {
                    try context.save()
                } catch {
                    throw DomainError.persistenceError
                }
            },
            cacheImage: { breedId, urlString, context in
                guard let url = URL(string: urlString) else { return }
                let descriptor = FetchDescriptor<CatBreed>(
                    predicate: #Predicate { $0.id == breedId }
                )
                guard let breed = try? context.fetch(descriptor).first else { return }
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    breed.imageData = data
                    try context.save()
                } catch {
                    throw DomainError.decodingError
                }
            }
        )
    }
}
