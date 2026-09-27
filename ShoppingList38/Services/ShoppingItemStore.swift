//
//  ShoppingItemStore.swift
//  ShoppingList38
//
//  Created by Сергей Хмелёв on 27.09.2026.
//

import Foundation
import SwiftData

/// Выполняет операции с товарами в переданном контексте SwiftData.
@MainActor
struct ShoppingItemStore {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    @discardableResult
    func create(
        in shoppingList: ShoppingList,
        title: String,
        quantity: Double,
        unit: String
    ) throws -> ShoppingItem {
        let item = ShoppingItem(
            title: title,
            quantity: quantity,
            unit: unit,
            shoppingList: shoppingList
        )

        modelContext.insert(item)
        try saveChanges()

        return item
    }

    func update(
        _ item: ShoppingItem,
        title: String,
        quantity: Double,
        unit: String
    ) throws {
        item.update(
            title: title,
            quantity: quantity,
            unit: unit
        )
        try saveChanges()
    }

    func togglePurchased(_ item: ShoppingItem) throws {
        item.togglePurchased()
        try saveChanges()
    }

    func delete(_ item: ShoppingItem) throws {
        modelContext.delete(item)
        try saveChanges()
    }

    private func saveChanges() throws {
        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            throw error
        }
    }
}
