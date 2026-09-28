//
//  MyListsView+Observed.swift
//  ShoppingList38
//
//  Created by Сергей Хмелёв on 27.09.2026.
//

import Foundation
import Observation
import SwiftData

extension MyListsView {
    @MainActor
    @Observable
    final class Observed {
        private(set) var listPendingDeletion: ShoppingList?
        private(set) var persistenceErrorMessage: String?

        var isShowingDeleteConfirmation: Bool {
            get {
                listPendingDeletion != nil
            }
            set {
                if !newValue {
                    listPendingDeletion = nil
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

        func handleCreateButtonTapped(router: AppRouter) {
            router.navigate(to: .createList)
        }

        func handleEditButtonTapped(
            for shoppingList: ShoppingList,
            router: AppRouter
        ) {
            router.navigate(to: .editList(id: shoppingList.id))
        }

        func handleDeleteButtonTapped(for shoppingList: ShoppingList) {
            listPendingDeletion = shoppingList
        }

        func handleDeleteCancellation() {
            listPendingDeletion = nil
        }

        func handlePersistenceErrorDismissal() {
            persistenceErrorMessage = nil
        }

        func handleDuplicate(
            _ shoppingList: ShoppingList,
            modelContext: ModelContext
        ) {
            handlePersistenceOperation {
                _ = try makeStore(modelContext: modelContext).duplicate(shoppingList)
            }
        }

        func handleDeleteConfirmation(
            _ shoppingList: ShoppingList,
            modelContext: ModelContext
        ) {
            listPendingDeletion = nil

            handlePersistenceOperation {
                try makeStore(modelContext: modelContext).delete(shoppingList)
            }
        }

        @discardableResult
        private func handlePersistenceOperation(
            _ operation: () throws -> Void
        ) -> Bool {
            do {
                try operation()
                return true
            } catch {
                persistenceErrorMessage = error.localizedDescription
                return false
            }
        }

        private func makeStore(modelContext: ModelContext) -> ShoppingListStore {
            ShoppingListStore(modelContext: modelContext)
        }
    }
}
