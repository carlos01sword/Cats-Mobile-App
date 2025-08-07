//
//  Loading.swift
//  CatsApp
//
//  Created by Carlos Costa on 07/08/2025.
//

import Foundation
import SwiftData

extension CatListViewModel {
    
    func loadInitial(context: ModelContext) async {
        guard catBreeds.isEmpty else { return }

        currentPage = 0
        canLoadMore = true
        catBreeds = []

        await loadPage(context: context, isInitial: true)
    }

    func loadMore(context: ModelContext) async {
        guard !isLoading, canLoadMore else { return }
        await loadPage(context: context, isInitial: false)
    }

    private func loadPage(context: ModelContext, isInitial: Bool) async {
        isLoading = true
        defer { isLoading = false }

        let service = CatDataService()
        let result = await service.fetchCatsData(page: currentPage, limit: pageSize)

        switch result {
        case .success(let apiBreeds):
            if apiBreeds.isEmpty {
                canLoadMore = false
            } else {
                currentPage += 1
                await storeBreeds(apiBreeds, in: context)
            }

        case .failure(let error):
            await handleFetchFailure(error, context: context)
        }
    }
}
