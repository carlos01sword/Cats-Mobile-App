//
//  CatDataViewModel.swift
//  CatsApp
//
//  Created by Carlos Costa on 03/08/2025.
//

import Foundation

@MainActor
final class CatListViewModel: ObservableObject {
    @Published var catBreeds: [CatBreed] = []

    func loadBreeds() async {
        let breeds = await CatDataService().fetchCatsData()
        self.catBreeds = breeds
    }
}
