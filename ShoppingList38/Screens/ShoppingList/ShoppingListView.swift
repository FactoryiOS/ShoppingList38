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

        Group {
            if items.isEmpty {
                EmptyStateView(
                    imageName: "EmptyProductsImage",
                    title: "Давайте спланируем покупки!",
                    subtitle: "Начните добавлять товары",
                    imageSize: 343
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                itemsList
            }
        }
        .background(Color("SurfaceBackground"))
        .searchable(
            text: $observed.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Поиск"
        )
        .navigationTitle(shoppingList.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
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
        .alert(
            "Удаление товара",
            isPresented: $observed.isShowingDeleteConfirmation,
            presenting: observed.itemPendingDeletion
        ) { item in
            Button("Отменить", role: .cancel) {
                observed.handleDeleteCancellation()
            }

            Button("Удалить", role: .destructive) {
                observed.handleDeleteConfirmation(
                    item,
                    modelContext: modelContext
                )
            }
        } message: { _ in
            Text("Вы действительно хотите удалить товар?")
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
                let isPendingDeletion = observed.itemPendingDeletion?.id == item.id

                ShoppingItemView(item: item) {
                    observed.handleTogglePurchased(
                        item,
                        modelContext: modelContext
                    )
                }
                .background(Color("SurfaceBackground"))
                .offset(x: isPendingDeletion ? -80 : 0)
                .background(alignment: .trailing) {
                    ZStack {
                        Color.deleteAction

                        Image(systemName: "trash")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 80)
                    .opacity(isPendingDeletion ? 1 : 0)
                }
                .animation(
                    .easeInOut(duration: 0.25),
                    value: isPendingDeletion
                )
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color("SurfaceBackground"))
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        observed.handleDeleteButtonTapped(for: item)
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
