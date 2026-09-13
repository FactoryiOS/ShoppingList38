//
//  EmptyStateView.swift
//  ShoppingList38
//
//  Created by Leo Gabuev on 13.09.2026.
//

import SwiftUI

struct EmptyStateView: View {
    let imageName: String
    let title: String
    let subtitle: String
    let imageSize: CGFloat
    
    var body: some View {
        VStack(spacing: AppLayout.emptyStateVerticalSpacing) {
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)

            VStack(spacing: AppLayout.emptyStateTextSpacing) {
                
                Text(title)
                    .font(AppTypography.title3Semibold)

                Text(subtitle)
                    .font(AppTypography.body)
            }
            .multilineTextAlignment(.center)
            .foregroundStyle(.primaryText)
        }
        .padding(.horizontal, AppLayout.emptyStateHorizontalPadding)
    }
}

#Preview("Списки") {
    EmptyStateView(
        imageName: "EmptyListsImage",
        title: "Давайте спланируем покупки!",
        subtitle: "Создайте свой первый список",
        imageSize: AppLayout.emptyStateImageSizeLists
    )
}

#Preview("Товары") {
    EmptyStateView(
        imageName: "EmptyProductsImage",
        title: "Давайте спланируем покупки!",
        subtitle: "Начните добавлять товары",
        imageSize: AppLayout.emptyStateImageSizeItems
    )
}
