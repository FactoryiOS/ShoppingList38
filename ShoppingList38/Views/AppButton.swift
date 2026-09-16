//
//  AppButton.swift
//  ShoppingList38
//
//  Created by Leo Gabuev on 14.09.2026.
//

import SwiftUI

struct AppButton: View {
    
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.headline)
                .foregroundStyle(
                    isActive ? .white : .disabledButtonText
                )
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    isActive ? .primaryAction : .disabledButton
                )
                .clipShape(Capsule())
        }
        .disabled(!isActive)
    }
}

#Preview("Light - Active") {
    AppButton(title: "Создать список", isActive: true) {}
        .padding(16)
        .preferredColorScheme(.light)
}

#Preview("Light - Disabled") {
    AppButton(title: "Создать", isActive: false) {}
        .padding(16)
        .preferredColorScheme(.light)
}

#Preview("Dark - Active") {
    AppButton(title: "Создать список", isActive: true) {}
        .padding(16)
        .preferredColorScheme(.dark)
}

#Preview("Dark - Disabled") {
    AppButton(title: "Создать", isActive: false) {}
        .padding(16)
        .preferredColorScheme(.dark)
}
