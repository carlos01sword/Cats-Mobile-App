//
//  DataService.swift
//  CatsApp
//
//  Created by Carlos Costa on 03/08/2025.
//

import Foundation

final class CatAPIService {
    func fetchCatsData() async {
        let urlString = "https://api.thecatapi.com/v1/breeds"
        guard let url = URL(string: urlString) else {
            return
        }

        var request = URLRequest(url: url)
        request.addValue("live_qZSunkWQL4nxKItjmfA2TcTwIolM00gM2zU489lP9X7oCLuxzHp7nSzvBAApOOY", forHTTPHeaderField: "x-api-key")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }
}
