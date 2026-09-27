//
//  ShoppingItemView.swift
//  ShoppingList38
//
//  Created by Сергей Бушков on 17.09.2026.
//

import SwiftUI

struct ShoppingItemView: View {
    let item: ShoppingItem
    let onTogglePurchased: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            checkboxView

            Text(item.title)
                .font(AppTypography.body)
                .foregroundStyle(textColor)

            Spacer()

            Text("\(formattedQuantity) \(item.unit)")
                .font(AppTypography.body)
                .foregroundStyle(textColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color("AppSeparator"))
                .frame(height: 0.5)
        }
    }

    private var formattedQuantity: String {
        item.quantity.formatted(
            .number.precision(.fractionLength(0...2))
        )
    }

    private var textColor: Color {
        item.isPurchased ? Color("ListSecondaryText") : Color("PrimaryText")
    }

    private var checkboxView: some View {
        Button(action: onTogglePurchased) {
            Group {
                if item.isPurchased {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color("PrimaryAction"))
                            .frame(width: 24, height: 24)

                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                } else {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color("ListSecondaryText"), lineWidth: 1.5)
                        .frame(width: 24, height: 24)
                }
            }
            .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            item.isPurchased ? "Отметить как некупленное" : "Отметить как купленное"
        )
    }
}

#Preview {
    VStack(spacing: 0) {
        ShoppingItemView(
            item: .mockNotPurchased,
            onTogglePurchased: {}
        )
        ShoppingItemView(
            item: .mockPurchased,
            onTogglePurchased: {}
        )
    }
}
