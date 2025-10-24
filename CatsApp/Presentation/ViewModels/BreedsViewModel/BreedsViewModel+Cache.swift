import SwiftData

extension BreedsViewModel {
    func handleFetchFailure(_ error: DomainError, context: ModelContext) async {
        let hadDataBefore = !catBreeds.isEmpty
        let loadedFromCache = await loadCachedBreeds(from: context)
        if loadedFromCache {
            transition(to: .endReached)
        } else if !hadDataBefore {
            transition(to: .error(error))
        } else if state == .pageLoading {
            transition(to: .idle)
        }
    }

    @discardableResult
    private func loadCachedBreeds(from context: ModelContext) async -> Bool {
        do {
            let saved = try repository.fetchAll(context)
            guard !saved.isEmpty else { return false }
            catBreeds = saved
            currentPage = catBreeds.count / pageSize
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
        if let saved = try? repository.fetchAll(context),
            !saved.isEmpty
        {
            catBreeds = saved
            currentPage = catBreeds.count / pageSize
            if state == .idle {} else { transition(to: .idle) }
        }
    }
}
