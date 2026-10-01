//
//  ShoppingListView+Observed.swift
//  ShoppingList38
//
//  Created by Сергей Бушков on 22.09.2026.
//

import Foundation
import Observation
import SwiftData
import SwiftUI

extension ShoppingListView {
    @MainActor
    @Observable
    final class Observed {
        var searchText = ""
        private(set) var itemPendingDeletion: ShoppingItem?
        private(set) var persistenceErrorMessage: String?

        var isShowingDeleteConfirmation: Bool {
            get {
                itemPendingDeletion != nil
            }
            set {
                if !newValue {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        itemPendingDeletion = nil
                    }
                }
            }
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

        func filteredItems(_ items: [ShoppingItem]) -> [ShoppingItem] {
            guard !searchText.isEmpty else {
                return items
            }

            return items.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }

        func handleDeleteButtonTapped(for item: ShoppingItem) {
            withAnimation(.easeInOut(duration: 0.25)) {
                itemPendingDeletion = item
            }
        }

        func handleDeleteCancellation() {
            withAnimation(.easeInOut(duration: 0.25)) {
                itemPendingDeletion = nil
            }
        }

        func handleDeleteConfirmation(
            _ item: ShoppingItem,
            modelContext: ModelContext
        ) {
            withAnimation(.easeInOut(duration: 0.25)) {
                itemPendingDeletion = nil
                handlePersistenceOperation {
                    try makeStore(modelContext: modelContext).delete(item)
                }
            }
        }

        func handleTogglePurchased(
            _ item: ShoppingItem,
            modelContext: ModelContext
        ) {
            handlePersistenceOperation {
                try makeStore(modelContext: modelContext).togglePurchased(item)
            }
        }

        func handleEditItem(
            _ item: ShoppingItem,
            in shoppingList: ShoppingList,
            router: AppRouter
        ) {
            router.showModal(
                .editItem(
                    shoppingListID: shoppingList.id,
                    itemID: item.id
                )
            )
        }

        func handleAddItem(
            to shoppingList: ShoppingList,
            router: AppRouter
        ) {
            router.showModal(
                .createItem(shoppingListID: shoppingList.id)
            )
        }

        func handlePersistenceErrorDismissal() {
            persistenceErrorMessage = nil
        }

        private func handlePersistenceOperation(
            _ operation: () throws -> Void
        ) {
            do {
                try operation()
            } catch {
                persistenceErrorMessage = error.localizedDescription
            }
        }

        private func makeStore(modelContext: ModelContext) -> ShoppingItemStore {
            ShoppingItemStore(modelContext: modelContext)
        }
    }
}
