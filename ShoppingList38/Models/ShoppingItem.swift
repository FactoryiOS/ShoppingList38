//
//  ShoppingItem.swift
//  ShoppingList38
//
//  Created by Сергей Бушков on 17.09.2026.
//

import Foundation
import SwiftData

/// Элемент списка покупок, сохраняемый в SwiftData.
@Model
final class ShoppingItem {
    @Attribute(.unique) var id: UUID

    private(set) var title: String
    private(set) var quantity: Double
    private(set) var unit: String
    private(set) var isPurchased: Bool
    private(set) var createdAt: Date
    private(set) var updatedAt: Date

    var shoppingList: ShoppingList?

    init(
        id: UUID = UUID(),
        title: String,
        quantity: Double,
        unit: String,
        isPurchased: Bool = false,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        shoppingList: ShoppingList? = nil
    ) {
        self.id = id
        self.title = title
        self.quantity = quantity
        self.unit = unit
        self.isPurchased = isPurchased
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.shoppingList = shoppingList
    }

    func update(
        title: String,
        quantity: Double,
        unit: String,
        updatedAt: Date = .now
    ) {
        self.title = title
        self.quantity = quantity
        self.unit = unit
        self.updatedAt = updatedAt
    }

    func togglePurchased(updatedAt: Date = .now) {
        isPurchased.toggle()
        self.updatedAt = updatedAt
    }
}

extension ShoppingItem {
    static var mockNotPurchased: ShoppingItem {
        ShoppingItem(
            title: "текст",
            quantity: 2,
            unit: "шт",
            isPurchased: false
        )
    }

    static var mockPurchased: ShoppingItem {
        ShoppingItem(
            title: "Чайник",
            quantity: 2,
            unit: "шт",
            isPurchased: true
        )
    }

    static var mock: ShoppingItem {
        mockNotPurchased
    }

    static var mocks: [ShoppingItem] {
        [
            ShoppingItem(title: "текст", quantity: 2, unit: "шт", isPurchased: false),
            ShoppingItem(title: "текст", quantity: 2, unit: "шт", isPurchased: false),
            ShoppingItem(title: "Чайник", quantity: 2, unit: "шт", isPurchased: true),
            ShoppingItem(title: "текст", quantity: 2, unit: "шт", isPurchased: false)
        ]
    }
}
