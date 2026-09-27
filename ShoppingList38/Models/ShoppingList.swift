//
//  ShoppingList.swift
//  ShoppingList38
//

import Foundation
import SwiftData

/// Список покупок, сохраняемый в SwiftData.
@Model
final class ShoppingList {
    @Attribute(.unique) var id: UUID

    private(set) var name: String
    private(set) var colorRawValue: String
    private(set) var iconRawValue: String
    private(set) var createdAt: Date
    private(set) var updatedAt: Date

    var color: ListColor {
        ListColor(rawValue: colorRawValue) ?? .blue
    }

    var icon: ListIcon {
        ListIcon(rawValue: iconRawValue) ?? .cart
    }

    init(
        id: UUID = UUID(),
        name: String,
        color: ListColor,
        icon: ListIcon,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.name = name
        colorRawValue = color.rawValue
        iconRawValue = icon.rawValue
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    func update(
        name: String,
        color: ListColor,
        icon: ListIcon,
        updatedAt: Date = .now
    ) {
        self.name = name
        colorRawValue = color.rawValue
        iconRawValue = icon.rawValue
        self.updatedAt = updatedAt
    }
}
