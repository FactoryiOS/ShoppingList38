//
//  ListItemView.swift
//  ShoppingList38
//
//  Created by Leo Gabuev on 15.09.2026.
//

import SwiftUI

struct ListItemView: View {
    let shoppingList: ShoppingList

    var body: some View {
        HStack(spacing: 12) {
            Image(shoppingList.icon.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 21, height: 21)
                .frame(width: 48, height: 48)
                .background(shoppingList.color.color)
                .clipShape(Circle())
                .foregroundStyle(.iconForeground)

            Text(shoppingList.name)
                .font(AppTypography.title3Semibold)

            Spacer()

            HStack(spacing: 0) {
                Text("0/")
                    .font(AppTypography.body)
                Text("0")
                    .font(AppTypography.headline)
            }
        }
        .padding(16)
        .frame(height: 84)
        .foregroundStyle(.primaryText)
        .background(.surfaceBackground)
        .cornerRadius(16)
    }
}

#Preview("Light") {
    ZStack {
        Color("AppBackground").ignoresSafeArea()
        ListItemView(
            shoppingList: ShoppingList(
                name: "Новый год",
                color: .blue,
                icon: .calendar
            )
        )
            .padding()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    ZStack {
        Color("AppBackground").ignoresSafeArea()
        ListItemView(
            shoppingList: ShoppingList(
                name: "Новый год",
                color: .blue,
                icon: .calendar
            )
        )
            .padding()
    }
    .preferredColorScheme(.dark)
}
