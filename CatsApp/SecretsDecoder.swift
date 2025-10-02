//
//  SecretsD.swift
//  CatsApp
//
//  Created by Carlos Costa on 02/10/2025.
//

import Foundation

enum SecretsDecoder{
    static var breedsApiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "BREEDS_API_KEY") as? String else {
            fatalError("API Key not found")
        }
        return key
    }
}
