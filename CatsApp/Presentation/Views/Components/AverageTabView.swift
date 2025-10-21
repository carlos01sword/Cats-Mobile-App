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
                .frame(height: .averageTabViewHeight)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: .averageTabViewCornerRadius)
                        .fill(Color(.systemGray6))
                        .shadow()
                        .padding(.horizontal)
                )
        }
    }
}

private extension CGFloat {
   static let averageTabViewCornerRadius: Self = 18
   static let averageTabViewHeight: Self = 36
}
#if DEBUG
#Preview {
    AverageTabView(breeds: MockData.breeds)
}
#endif
