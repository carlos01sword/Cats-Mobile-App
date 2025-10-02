//
//  CatsAppTests.swift
//  CatsAppTests
//
//  Created by Carlos Costa on 01/08/2025.
//

import Testing
@testable import CatsApp

struct CatsAppTests {
    
    @Test func testAverageLifeSpan() throws {
        let breeds = [
            CatBreed(id: "1", name: "", origin: "", temperament: "", breedDescription: "", lifeSpan: "10 - 12"),
            CatBreed(id: "2", name: "", origin: "", temperament: "", breedDescription: "", lifeSpan: "14 - 16"),
            CatBreed(id: "3", name: "", origin: "", temperament: "", breedDescription: "", lifeSpan: "12 - 15")
        ]

        let result = Average.averageLifeSpan(from: breeds)
        #expect(result == 14) // (12 + 16 + 15) / 3 = 14.3333 = 14
    }

    @Test func testAverageLifeSpanEmpty() throws {
        let breeds: [CatBreed] = []
        let result = Average.averageLifeSpan(from: breeds)
        #expect(result == 0)
    }
    
    @Test func testDefaultFavoriteFalse() throws {
            let breed = CatBreed(
                id: "1",
                name: "Test",
                origin: "",
                temperament: "",
                breedDescription: "",
                lifeSpan: ""
            )
            #expect(breed.isFavorite == false)
        }
    
    @Test func testToggleFavorite() throws {
           let breed = CatBreed(
               id: "1",
               name: "Test",
               origin: "",
               temperament: "",
               breedDescription: "",
               lifeSpan: ""
           )
           #expect(breed.isFavorite == false)
           breed.isFavorite.toggle()
           #expect(breed.isFavorite == true)
           breed.isFavorite.toggle()
           #expect(breed.isFavorite == false)
       }
}
