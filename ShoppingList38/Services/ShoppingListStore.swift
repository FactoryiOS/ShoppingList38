//
//  ShoppingListStore.swift
//  ShoppingList38
//
//  Created by Сергей Хмелёв on 27.09.2026.
//

import Foundation
import SwiftData

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
        shoppingList.update(
            name: name,
            color: color,
            icon: icon
        )
        try saveChanges()
    }

    @discardableResult
    func duplicate(_ shoppingList: ShoppingList) throws -> ShoppingList {
        let existingNames = try modelContext
            .fetch(FetchDescriptor<ShoppingList>())
            .map(\.name)
        let copy = ShoppingList(
            name: makeCopyName(
                for: shoppingList.name,
                existingNames: existingNames
            ),
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

    private func makeCopyName(
        for name: String,
        existingNames: [String]
    ) -> String {
        let normalizedNames = Set(existingNames.map(Self.normalize))
        var baseName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        var copyNumber = 1

        if let separator = baseName.lastIndex(where: { $0.isWhitespace }) {
            let suffix = baseName[baseName.index(after: separator)...]

            if suffix.allSatisfy({ $0.isNumber }),
               let number = Int(suffix),
               number < Int.max {
                baseName = String(baseName[..<separator])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                copyNumber = number + 1
            }
        }

        while normalizedNames.contains(Self.normalize("\(baseName) \(copyNumber)")) {
            copyNumber += 1
        }

        return "\(baseName) \(copyNumber)"
    }

    private static func normalize(_ name: String) -> String {
        name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(
                options: [.caseInsensitive, .diacriticInsensitive],
                locale: .current
            )
    }
}
