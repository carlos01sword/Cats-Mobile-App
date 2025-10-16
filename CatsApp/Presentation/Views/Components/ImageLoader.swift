//  ShimmerPlaceholder.swift
//  CatsApp
//
// Created by Carlos Costa on 01/10/2025.
//
import SwiftUI

struct ImageLoader: View {

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: ConstantsUI.defaultCornerRadius, style: .continuous)
                .fill(ConstantsUI.shimmerBaseColor)
            ProgressView()
                .progressViewStyle(.circular)
        }
        .accessibilityHidden(true)
    }
}

private extension CGFloat {
    static let previewFrame: Self = 120
}

#Preview {
    ImageLoader()
        .frame(width: .previewFrame, height: .previewFrame)
        .padding()
}
