//
//  AvgView.swift
//  CatsApp
//
//  Created by Carlos Costa on 06/08/2025.
//

import SwiftUI

struct AverageTabView: View {
    let breeds: [CatBreed]

    var body: some View {
        if !breeds.isEmpty {
            let avg = Average.averageLifeSpan(from: breeds)

            Text("Average lifespan: \(avg) years")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .frame(height: 36)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.systemGray6))
                        .shadow(color: Color(.systemGray3), radius: 2, x: 0, y: 1)
                        .padding(.horizontal)
                )
        }
    }
}

#Preview {
    AverageTabView(breeds: MockData.breeds)
}
