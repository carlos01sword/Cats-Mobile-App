//
//  Cache.swift
//  CatsApp
//
//  Created by Carlos Costa on 07/08/2025.
//

import SwiftData

extension BreedsViewModel {
    func handleFetchFailure(_ error: DomainError, context: ModelContext) async {
        let hadDataBefore = !catBreeds.isEmpty
        let loadedFromCache = await loadCachedBreeds(from: context)
        if loadedFromCache {
            transition(to: .endReached)
        } else if !hadDataBefore {
            transition(to: .error(error))
        } else if phase == .pageLoading {
            transition(to: .idle)
        }
    }

    @discardableResult
    private func loadCachedBreeds(from context: ModelContext) async -> Bool {
        do {
            let saved = try repository.fetchAll(context: context)
            guard !saved.isEmpty else { return false }
            catBreeds = saved
            return true
        } catch let domainError as DomainError {
            print("Cache fetch error: \(domainError)")
            return false
        } catch {
            print("Cache fetch error: \(error)")
            return false
        }
    }
    
    func loadCachedIfAvailable(context: ModelContext) {
        guard catBreeds.isEmpty else { return }
        if let saved = try? repository.fetchAll(context: context), !saved.isEmpty {
            catBreeds = saved
            if phase == .idle { } else { transition(to: .idle) }
        }
    }
}
