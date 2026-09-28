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
        let now = Date.now
        let item = ShoppingItem(
            title: title,
            quantity: quantity,
            unit: unit,
            createdAt: now,
            updatedAt: now,
            shoppingList: shoppingList
        )

        modelContext.insert(item)
        shoppingList.touch(updatedAt: now)
        try saveChanges()

        return item
    }

    func update(
        _ item: ShoppingItem,
        title: String,
        quantity: Double,
        unit: String
    ) throws {
        let now = Date.now
        item.update(
            title: title,
            quantity: quantity,
            unit: unit,
            updatedAt: now
        )
        item.shoppingList?.touch(updatedAt: now)
        try saveChanges()
    }

    func togglePurchased(_ item: ShoppingItem) throws {
        let now = Date.now
        item.togglePurchased(updatedAt: now)
        item.shoppingList?.touch(updatedAt: now)
        try saveChanges()
    }

    func delete(_ item: ShoppingItem) throws {
        let shoppingList = item.shoppingList
        modelContext.delete(item)
        shoppingList?.touch()
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
