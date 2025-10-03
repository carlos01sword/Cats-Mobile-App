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
        let result = await repository.fetchPage(page: currentPage, limit: pageSize, context: context)
        switch result {
        case .success(let pageResult):
            let fetchedCount = pageResult.fetchedCount
            catBreeds = pageResult.breeds
            guard fetchedCount > 0 else {
                transition(to: .endReached)
                return
            }
            advancePage()
            let reachedEnd = fetchedCount < pageSize
            transition(to: reachedEnd ? .endReached : .idle)
        case .failure(let domainError):
            transition(to: .error(domainError))
            await handleFetchFailure(domainError, context: context)
        }
    }
}
