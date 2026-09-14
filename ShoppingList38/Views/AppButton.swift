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
                    isActive ? AppColors.surfaceBackground : AppColors.disabledButtonText
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    isActive ? AppColors.primaryAction : AppColors.disabledButton
                )
                .clipShape(Capsule())
        }
        .disabled(!isActive)
    }
}

#Preview("Active") {
    AppButton(title: "Создать список", isActive: true) {}
        .padding(16)
}

#Preview("Disabled") {
    AppButton(title: "Создать", isActive: false) {}
        .padding(16)
}
