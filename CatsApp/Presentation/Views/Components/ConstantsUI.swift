//
//  ConstantsUI.swift
//  CatsApp
//
//  Created by Carlos Costa on 16/10/2025.
//

import Foundation
import SwiftUI

struct ConstantsUI {
    // Corner radius
    static let defaultCornerRadius: CGFloat = 8
    static let largeCornerRadius: CGFloat = 24
    static let rowCornerRadius: CGFloat = 16
    static let favoritesButtonCornerRadius: CGFloat = 12
    static let averageTabViewCornerRadius: CGFloat = 18

    // Spacing
    static let defaultVerticalSpacing: CGFloat = 10
    static let largeVerticalSpacing: CGFloat = 24
    static let rowSpacing: CGFloat = 16
    static let favoritesButtonVerticalPadding: CGFloat = 12
    static let cardVerticalSpacing: CGFloat = 32
    
    // Sizes
    static let breedThumbnailSize: CGFloat = 60
    static let emptyStateIconSize: CGFloat = 40
    static let searchEmptyStateIconSize: CGFloat = 36
    static let favoritesButtonMinWidth: CGFloat = 220
    static let averageTabViewHeight: CGFloat = 36
    static let previewFrame: CGFloat = 120
    
    // Opacity
    static let shimmerBaseOpacity: Double = 0.18
    
    // Color
    static let shimmerBaseColor: Color = Color.gray.opacity(0.18)
    
    // Loading
    static let loadingScale: Double = 1.2
    static let loadingPadding: Double = 12
}
