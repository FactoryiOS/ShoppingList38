//
//  ShoppingListStore.swift
//  ShoppingList38
//
//  Created by Сергей Хмелёв on 27.09.2026.
//

import Foundation
import SwiftData

nonisolated enum ShoppingListStoreError: LocalizedError {
    case duplicateName

    var errorDescription: String? {
        "Это название уже используется, пожалуйста, измените его."
    }
}

/// Выполняет операции со списками в переданном контексте SwiftData.
@MainActor
struct ShoppingListStore {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    @discardableResult
    func create(
        name: String,
        color: ListColor,
        icon: ListIcon
    ) throws -> ShoppingList {
        try validateUniqueName(name)

        let shoppingList = ShoppingList(
            name: name,
            color: color,
            icon: icon
        )

        modelContext.insert(shoppingList)
        try saveChanges()

        return shoppingList
    }

    func update(
        _ shoppingList: ShoppingList,
        name: String,
        color: ListColor,
        icon: ListIcon
    ) throws {
        try validateUniqueName(name, excluding: shoppingList.id)

        shoppingList.update(
            name: name,
            color: color,
            icon: icon
        )
        try saveChanges()
    }

    @discardableResult
    func duplicate(_ shoppingList: ShoppingList) throws -> ShoppingList {
        let existingNormalizedNames = try modelContext
            .fetch(FetchDescriptor<ShoppingList>())
            .map(\.normalizedName)
        let copyName = ShoppingListName.makeCopyName(
            for: shoppingList.name,
            existingNormalizedNames: Set(existingNormalizedNames)
        )
        try validateUniqueName(copyName)

        let copy = ShoppingList(
            name: copyName,
            color: shoppingList.color,
            icon: shoppingList.icon
        )

        modelContext.insert(copy)

        for item in shoppingList.items.sorted(by: { $0.createdAt < $1.createdAt }) {
            let itemCopy = ShoppingItem(
                title: item.title,
                quantity: item.quantity,
                unit: item.unit,
                isPurchased: false,
                shoppingList: copy
            )

            modelContext.insert(itemCopy)
        }

        try saveChanges()

        return copy
    }

    func delete(_ shoppingList: ShoppingList) throws {
        modelContext.delete(shoppingList)
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

    private func validateUniqueName(_ name: String, excluding id: UUID? = nil) throws {
        let normalizedName = ShoppingListName.normalize(name)
        let predicate: Predicate<ShoppingList>

        if let id {
            predicate = #Predicate { shoppingList in
                shoppingList.normalizedName == normalizedName && shoppingList.id != id
            }
        } else {
            predicate = #Predicate { shoppingList in
                shoppingList.normalizedName == normalizedName
            }
        }

        var descriptor = FetchDescriptor<ShoppingList>(predicate: predicate)
        descriptor.fetchLimit = 1

        guard try modelContext.fetch(descriptor).isEmpty else {
            throw ShoppingListStoreError.duplicateName
        }
    }
}
