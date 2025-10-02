//
//  Loading.swift
//  CatsApp
//
//  Created by Carlos Costa on 07/08/2025.
//

import Foundation
import SwiftData

extension BreedsViewModel {
    
    func loadInitial(context: ModelContext) async {
        guard catBreeds.isEmpty else { return }
        resetPaging()
        transition(to: .initialLoading)
        await loadPage(context: context, isInitial: true)
    }

    func loadMore(context: ModelContext) async {
        guard !isLoading, canLoadMore else { return }
        if phase != .initialLoading { transition(to: .pageLoading) }
        await loadPage(context: context, isInitial: false)
    }

    private func loadPage(context: ModelContext, isInitial: Bool) async {
        let result = await fetchPage(page: currentPage, limit: pageSize)
        switch result {
        case .success(let apiBreeds):
            guard !apiBreeds.isEmpty else {
                transition(to: .endReached)
                return
            }
            advancePage()
            await storeBreeds(apiBreeds, in: context)
            transition(to: apiBreeds.count < pageSize ? .endReached : .idle)
        case .failure(let error):
            transition(to: .error(error.localizedDescription))
            await handleFetchFailure(error, context: context)
        }
    }
}
