//
//  ShoppingList.swift
//  ShoppingList38
//
//  Created by Сергей Хмелёв on 27.09.2026.
//

import Foundation
import OSLog
import SwiftData

/// Список покупок, сохраняемый в SwiftData.
@Model
final class ShoppingList {
    private static let logger = Logger(
        subsystem: "com-tsomuk.ShoppingList38",
        category: "ShoppingListPersistence"
    )

    @Attribute(.unique) var id: UUID

    private(set) var name: String
    @Attribute(.unique) private(set) var normalizedName: String
    private(set) var colorRawValue: String
    private(set) var iconRawValue: String
    private(set) var createdAt: Date
    private(set) var updatedAt: Date

    @Relationship(deleteRule: .cascade, inverse: \ShoppingItem.shoppingList)
    private(set) var items: [ShoppingItem] = []

    var color: ListColor {
        guard let color = ListColor(rawValue: colorRawValue) else {
            Self.logger.error("Неизвестный сохранённый цвет: \(self.colorRawValue, privacy: .public)")
            return .blue
        }

        return color
    }

    var icon: ListIcon {
        guard let icon = ListIcon(rawValue: iconRawValue) else {
            Self.logger.error("Неизвестная сохранённая иконка: \(self.iconRawValue, privacy: .public)")
            return .cart
        }

        return icon
    }

    var purchasedItemsCount: Int {
        items.filter(\.isPurchased).count
    }

    var totalItemsCount: Int {
        items.count
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
        normalizedName = ShoppingListName.normalize(name)
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
        normalizedName = ShoppingListName.normalize(name)
        colorRawValue = color.rawValue
        iconRawValue = icon.rawValue
        self.updatedAt = updatedAt
    }
}
