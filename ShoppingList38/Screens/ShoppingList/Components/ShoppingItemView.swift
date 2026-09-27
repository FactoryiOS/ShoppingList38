//
//  ShoppingItemView.swift
//  ShoppingList38
//
//  Created by Сергей Бушков on 17.09.2026.
//

import SwiftUI

struct ShoppingItemView: View {
    @Binding var item: ShoppingItem

    var body: some View {
        HStack(spacing: 12) {
            checkboxView

            Text(item.title)
                .font(AppTypography.body)
                .foregroundStyle(textColor)

            Spacer()

            Text("\(item.quantity) \(item.unit)")
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

    private var textColor: Color {
        item.isPurchased ? Color("ListSecondaryText") : Color("PrimaryText")
    }

    private var checkboxView: some View {
        Button {
            item.isPurchased.toggle()
        } label: {
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
    }
}

#Preview {
    @Previewable @State var notPurchasedItem = ShoppingItem.mockNotPurchased
    @Previewable @State var purchasedItem = ShoppingItem.mockPurchased

    VStack(spacing: 0) {
        ShoppingItemView(item: $notPurchasedItem)
        ShoppingItemView(item: $purchasedItem)
    }
}
