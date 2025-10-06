//  ShimmerPlaceholder.swift
//  CatsApp
//
// Created by Carlos Costa on 01/10/2025.
//
import SwiftUI

struct ImageLoader: View {
    var baseColor: Color = Color.gray.opacity(0.18)
    var cornerRadius: CGFloat = 8

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(baseColor)
            ProgressView()
                .progressViewStyle(.circular)
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    ImageLoader()
        .frame(width: 120, height: 120)
        .padding()
}
