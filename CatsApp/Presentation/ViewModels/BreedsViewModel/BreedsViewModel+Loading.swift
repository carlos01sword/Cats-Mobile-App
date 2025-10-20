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
        if state != .initialLoading { transition(to: .pageLoading) }
        await loadPage(context: context, isInitial: false)
    }

    private func loadPage(context: ModelContext, isInitial: Bool) async {
        do {
            let pageResult = try await repository.fetchPage(
                currentPage,
                pageSize,
                context
            )
            let fetchedCount = pageResult.fetchedCount
            catBreeds = pageResult.breeds
            guard fetchedCount > 0 else {
                transition(to: .endReached)
                return
            }
            advancePage()
            let reachedEnd = fetchedCount < pageSize
            transition(to: reachedEnd ? .endReached : .idle)
            Task.detached { [catBreeds] in
                for breed in catBreeds {
                    if breed.imageData == nil, let url = breed.referenceImageUrl
                    {
                        try? await self.repository.cacheImage(
                            breed.id,
                            url,
                            context
                        )
                    }
                }
            }
        } catch let domainError as DomainError {
            transition(to: .error(domainError))
            await handleFetchFailure(domainError, context: context)
        } catch {
            transition(to: .error(.networkError))
            await handleFetchFailure(.networkError, context: context)
        }
    }
}
