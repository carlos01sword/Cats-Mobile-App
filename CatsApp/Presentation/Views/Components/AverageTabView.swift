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
                .frame(height: ConstantsUI.averageTabViewHeight)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: ConstantsUI.averageTabViewCornerRadius)
                        .fill(Color(.systemGray6))
                        .applyShadow()
                        .padding(.horizontal)
                )
        }
    }
}

#Preview {
    AverageTabView(breeds: MockData.breeds)
}
