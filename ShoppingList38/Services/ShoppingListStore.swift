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
        let firstCandidate = "\(name) (копия)"

        guard normalizedNames.contains(Self.normalize(firstCandidate)) else {
            return firstCandidate
        }

        var copyNumber = 2

        while normalizedNames.contains(Self.normalize("\(name) (копия \(copyNumber))")) {
            copyNumber += 1
        }

        return "\(name) (копия \(copyNumber))"
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
