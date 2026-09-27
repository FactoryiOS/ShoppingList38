//
//  CreateEditItemView+Observed.swift
//  ShoppingList38
//
//  Created by Leo Gabuev on 21.09.2026.
//

import Foundation
import Observation
import SwiftData

extension CreateEditItemView {
    @MainActor
    @Observable
    final class Observed {
        let unit = "шт."

        var itemName: String
        var quantityText: String
        private(set) var persistenceErrorMessage: String?

        private let isEditing: Bool

        var navigationTitle: String {
            isEditing ? "Редактировать" : "Создание товара"
        }

        var isFormValid: Bool {
            makeDraft() != nil
        }

        var isShowingPersistenceError: Bool {
            get {
                persistenceErrorMessage != nil
            }
            set {
                if !newValue {
                    persistenceErrorMessage = nil
                }
            }
        }

        init(item: ShoppingItem?) {
            isEditing = item != nil
            itemName = item?.title ?? ""
            quantityText = item.map(Self.quantityText) ?? "1"
        }

        func handleSave(
            shoppingList: ShoppingList,
            item: ShoppingItem?,
            modelContext: ModelContext
        ) -> Bool {
            guard let draft = makeDraft() else {
                return false
            }

            do {
                let store = ShoppingItemStore(modelContext: modelContext)

                if let item {
                    try store.update(
                        item,
                        title: draft.title,
                        quantity: draft.quantity,
                        unit: draft.unit
                    )
                } else {
                    try store.create(
                        in: shoppingList,
                        title: draft.title,
                        quantity: draft.quantity,
                        unit: draft.unit
                    )
                }

                return true
            } catch {
                persistenceErrorMessage = error.localizedDescription
                return false
            }
        }

        func handlePersistenceErrorDismissal() {
            persistenceErrorMessage = nil
        }

        private func makeDraft() -> ItemDraft? {
            let title = itemName.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            let normalizedQuantity = quantityText
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: ",", with: ".")

            guard !title.isEmpty,
                  let quantity = Double(normalizedQuantity),
                  quantity.isFinite,
                  quantity > 0
            else {
                return nil
            }

            return ItemDraft(
                title: title,
                quantity: quantity,
                unit: unit
            )
        }

        private static func quantityText(for item: ShoppingItem) -> String {
            item.quantity.formatted(
                .number.precision(.fractionLength(0...2))
            )
        }
    }

    private struct ItemDraft {
        let title: String
        let quantity: Double
        let unit: String
    }
}
