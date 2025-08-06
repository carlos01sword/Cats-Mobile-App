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
}
