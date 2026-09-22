//
//  ShoppingListView.swift
//  ShoppingList38
//
//  Created by Сергей Бушков on 22.09.2026.
//

import SwiftUI

struct ShoppingListView: View {
    @State private var observed = Observed()

    var body: some View {
        @Bindable var observed = observed

        List {
            ForEach($observed.items) { $item in
                ShoppingItemView(item: $item)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color("SurfaceBackground"))
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            observed.deleteItem(item)
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.deleteAction)

                        Button {
                            observed.handleEditItem(item)
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                        .tint(.editAction)
                    }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color("SurfaceBackground"))
        .safeAreaInset(edge: .bottom) {
            AppButton(
                title: "Добавить товар",
                isActive: true,
                action: observed.handleAddItem
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color("SurfaceBackground"))
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: observed.handleMoreTapped) {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ShoppingListView()
    }
}
