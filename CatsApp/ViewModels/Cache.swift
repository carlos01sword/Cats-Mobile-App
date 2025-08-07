//
//  Cache.swift
//  CatsApp
//
//  Created by Carlos Costa on 07/08/2025.
//

import SwiftData

extension CatListViewModel {
    
    func handleFetchFailure(_ error: Error, context: ModelContext) async {
        fetchErrorMessage = error.localizedDescription
        await loadCachedBreeds(from: context)
    }

    private func loadCachedBreeds(from context: ModelContext) async {
        let descriptor = FetchDescriptor<CatBreed>()
        do {
            let saved = try context.fetch(descriptor)
            catBreeds = saved
            canLoadMore = false
        } catch {
            print(error.localizedDescription)
        }
    }
}
