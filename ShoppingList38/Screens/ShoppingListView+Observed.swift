//
//  ShoppingListView+Observed.swift
//  ShoppingList38
//
//  Created by Сергей Бушков on 22.09.2026.
//

import Foundation

extension ShoppingListView {
    @Observable
    final class Observed {
        var listTitle: String
        var items: [ShoppingItem]
        var searchText = ""

        init(
            listTitle: String = "Новый год",
            items: [ShoppingItem] = ShoppingItem.mocks
        ) {
            self.listTitle = listTitle
            self.items = items
        }
        
        var filteredItemIndices: [Int] {
            items.indices.filter { index in
                searchText.isEmpty ||
                items[index].title.localizedCaseInsensitiveContains(searchText)
            }
        }

        func deleteItem(_ item: ShoppingItem) {
            items.removeAll { $0.id == item.id }
        }

        func handleEditItem(_ item: ShoppingItem) {
            print("Edit item: \(item.title)")
        }

        func handleAddItem() {
            print("Add item tapped")
        }

        func handleMoreTapped() {
            print("More tapped")
        }
    }
}
