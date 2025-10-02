//
//  Cache.swift
//  CatsApp
//
//  Created by Carlos Costa on 07/08/2025.
//

import SwiftData

extension BreedsViewModel {
    
    func handleFetchFailure(_ error: Error, context: ModelContext) async {
        let hadDataBefore = !catBreeds.isEmpty
        let loadedFromCache = await loadCachedBreeds(from: context)
        if loadedFromCache {
            transition(to: .endReached)
        } else if !hadDataBefore {
            transition(to: .error(error.localizedDescription))
        } else {
            if phase == .pageLoading { transition(to: .idle) }
        }
    }

    @discardableResult
    private func loadCachedBreeds(from context: ModelContext) async -> Bool {
        let descriptor = FetchDescriptor<CatBreed>()
        do {
            let saved = try context.fetch(descriptor)
            if !saved.isEmpty {
                catBreeds = saved.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                return true
            }
            return false
        } catch {
            print("Cache fetch error: \(error.localizedDescription)")
            return false
        }
    }
}
