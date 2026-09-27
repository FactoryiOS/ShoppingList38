//
//  ShoppingListView.swift
//  ShoppingList38
//
//  Created by Сергей Бушков on 22.09.2026.
//

import SwiftData
import SwiftUI

struct ShoppingListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppRouter.self) private var router

    @Query private var items: [ShoppingItem]

    @State private var observed = Observed()

    private let shoppingList: ShoppingList

    init(shoppingList: ShoppingList) {
        self.shoppingList = shoppingList

        let shoppingListID = shoppingList.id
        _items = Query(
            filter: #Predicate<ShoppingItem> { item in
                item.shoppingList?.id == shoppingListID
            },
            sort: [SortDescriptor(\ShoppingItem.createdAt)]
        )
    }

    var body: some View {
        @Bindable var observed = observed

        VStack(spacing: 0) {
            itemsList
        }
        .background(Color("SurfaceBackground"))
        .searchable(
            text: $observed.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Поиск"
        )
        .navigationTitle(shoppingList.name)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            AppButton(
                title: "Добавить товар",
                isActive: true,
                action: {
                    observed.handleAddItem(
                        to: shoppingList,
                        router: router
                    )
                }
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
        .alert(
            "Не удалось изменить товар",
            isPresented: $observed.isShowingPersistenceError
        ) {
            Button("OK", role: .cancel) {
                observed.handlePersistenceErrorDismissal()
            }
        } message: {
            Text(observed.persistenceErrorMessage ?? "Неизвестная ошибка")
        }
    }

    private var itemsList: some View {
        List {
            ForEach(observed.filteredItems(items)) { item in
                ShoppingItemView(item: item) {
                    observed.handleTogglePurchased(
                        item,
                        modelContext: modelContext
                    )
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color("SurfaceBackground"))
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        observed.handleDelete(
                            item,
                            modelContext: modelContext
                        )
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.deleteAction)

                    Button {
                        observed.handleEditItem(
                            item,
                            in: shoppingList,
                            router: router
                        )
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .tint(.editAction)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    let shoppingList = ShoppingList(
        name: "Новый год",
        color: .blue,
        icon: .calendar
    )

    AppNavigationStack {
        ShoppingListView(shoppingList: shoppingList)
    }
    .modelContainer(
        for: [ShoppingList.self, ShoppingItem.self],
        inMemory: true
    )
}
