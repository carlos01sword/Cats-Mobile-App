//
//  ShadowModifier.swift
//  CatsApp
//
//  Created by Carlos Costa on 16/10/2025.
//

import SwiftUI

struct ShadowModifier: ViewModifier{
    func body(content: Content) -> some View {
        content.shadow(color: Color(.systemGray3), radius: 4, x: 0, y: 2)
    }
}


extension View {
    func applyShadow() -> some View {
        self.modifier(ShadowModifier())
    }
}
