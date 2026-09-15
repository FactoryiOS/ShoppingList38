//
//  ColorSelectorView.swift
//  ShoppingList38
//
//  Created by AntonA22 on 15.09.2026.
//

import SwiftUI

struct ColorSelectorView: View {

    @Environment(\.colorScheme) private var colorScheme

    let title: String
    @Binding var selectedColor: ListColor

    private var displayedColors: [ListColor] {
        colorScheme == .dark
            ? [.green, .purple, .blue, .red, .yellow]
            : ListColor.allCases
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AppTypography.body)
                .foregroundStyle(Color("PrimaryText"))

            HStack(spacing: 0) {
                ForEach(displayedColors) { listColor in
                    colorButton(for: listColor)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(16)
        .background(Color("SurfaceBackground"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func colorButton(for listColor: ListColor) -> some View {
        Button {
            selectedColor = listColor
        } label: {
            ZStack {
                Circle()
                    .fill(listColor.color)
                    .frame(width: 40, height: 40)

                if selectedColor == listColor {
                    Circle()
                        .stroke(Color("PrimaryAction"), lineWidth: 2)
                        .frame(width: 48, height: 48)
                }
            }
            .frame(width: 48, height: 48)
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel(for: listColor))
        .accessibilityAddTraits(selectedColor == listColor ? .isSelected : [])
    }

    private func accessibilityLabel(for listColor: ListColor) -> String {
        switch listColor {
        case .blue:
            "Голубой"
        case .green:
            "Зелёный"
        case .purple:
            "Фиолетовый"
        case .red:
            "Красный"
        case .yellow:
            "Жёлтый"
        }
    }
}

#Preview("Color selector - Light") {
    ColorSelectorPreview()
        .preferredColorScheme(.light)
}

#Preview("Color selector - Dark") {
    ColorSelectorPreview()
        .preferredColorScheme(.dark)
}

private struct ColorSelectorPreview: View {

    @State private var selectedColor = ListColor.blue

    var body: some View {
        ColorSelectorView(
            title: "Выберите цвет",
            selectedColor: $selectedColor
        )
        .padding(16)
        .background(Color("AppBackground"))
    }
}
