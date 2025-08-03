//
//  CatDataViewModel.swift
//  CatsApp
//
//  Created by Carlos Costa on 03/08/2025.
//

import Foundation
import Combine

@MainActor
final class CatListViewModel: ObservableObject {
    @Published var catBreeds: [CatBreed] = []
    @Published var searchText: String = ""

    var filteredBreeds: [CatBreed] {
        if searchText.isEmpty {
            return catBreeds
        } else {
            return catBreeds.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    func loadBreeds() async {
        let breeds = await CatDataService().fetchCatsData()
        self.catBreeds = breeds
    }

}


