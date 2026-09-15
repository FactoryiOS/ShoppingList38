//
//  IconSelectorView.swift
//  ShoppingList38
//
//  Created by AntonA22 on 15.09.2026.
//

import SwiftUI

struct IconSelectorView: View {

    @Environment(\.colorScheme) private var colorScheme

    let title: String
    let selectionColor: Color
    @Binding var selectedIcon: ListIcon

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 6
    )

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AppTypography.body)
                .foregroundStyle(Color("PrimaryText"))
                .padding(.horizontal, 8)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(ListIcon.allCases) { icon in
                    iconButton(for: icon)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
        .background(Color("SurfaceBackground"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func iconButton(for icon: ListIcon) -> some View {
        Button {
            selectedIcon = icon
        } label: {
            ZStack {
                Circle()
                    .fill(backgroundColor(for: icon))

                Image(icon.rawValue)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(iconColor(for: icon))
                    .frame(width: 24, height: 24)
            }
            .frame(maxWidth: 50)
            .aspectRatio(1, contentMode: .fit)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(icon.accessibilityName)
        .accessibilityAddTraits(selectedIcon == icon ? .isSelected : [])
    }

    private func backgroundColor(for icon: ListIcon) -> Color {
        selectedIcon == icon ? selectionColor : Color("IconBackground")
    }

    private func iconColor(for icon: ListIcon) -> Color {
        if selectedIcon == icon || colorScheme == .dark {
            return .black
        }

        return .white
    }
}

#Preview("Icon selector - Light") {
    IconSelectorPreview()
        .preferredColorScheme(.light)
}

#Preview("Icon selector - Dark") {
    IconSelectorPreview()
        .preferredColorScheme(.dark)
}

private struct IconSelectorPreview: View {

    @State private var selectedIcon = ListIcon.snowflake

    var body: some View {
        IconSelectorView(
            title: "Выберите дизайн",
            selectionColor: Color("ListColorBlue"),
            selectedIcon: $selectedIcon
        )
        .padding(16)
        .background(Color("AppBackground"))
    }
}
