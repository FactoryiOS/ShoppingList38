//
//  ListItemView.swift
//  ShoppingList38
//
//  Created by Leo Gabuev on 15.09.2026.
//

import SwiftUI

struct ListItemView: View {
    let item: ListItem

    var body: some View {
        HStack(spacing: 12) {
            Image(item.icon.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 21, height: 21)
                .frame(width: 48, height: 48)
                .background(item.iconColor)
                .clipShape(Circle())

            Text(item.title)
                .font(AppTypography.title3Semibold)

            Spacer()

            HStack(spacing: 0) {
                Text("\(item.currentCount)/")
                    .font(AppTypography.body)
                Text("\(item.totalCount)")
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
        ListItemView(item: ListItem.mock)
            .padding()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    ZStack {
        Color("AppBackground").ignoresSafeArea()
        ListItemView(item: ListItem.mock)
            .padding()
    }
    .preferredColorScheme(.dark)
}
