//
//  MyListsView.swift
//  ShoppingList38
//
//  Created by el on 23.09.2026.
//

import SwiftData
import SwiftUI

struct MyListsView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \ShoppingList.createdAt, order: .reverse)
    private var shoppingLists: [ShoppingList]

    @State private var observed = Observed()

    var body: some View {
        @Bindable var observed = observed

        VStack(spacing: 0) {
            header

            if shoppingLists.isEmpty {
                EmptyStateView(
                    imageName: "EmptyListsImage",
                    title: "Давайте спланируем покупки!",
                    subtitle: "Создайте свой первый список",
                    imageSize: 277
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                listsView
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            AppButton(title: "Создать список", isActive: true) {
                observed.handleCreateButtonTapped()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(.appBackground)
        .navigationDestination(isPresented: $observed.isCreatingList) {
            createListView
        }
        .navigationDestination(item: $observed.listBeingViewed) { shoppingList in
            ShoppingListView(listTitle: shoppingList.name)
        }
        .navigationDestination(item: $observed.listBeingEdited) { shoppingList in
            editListView(shoppingList)
        }
        .alert(
            "Удаление списка",
            isPresented: $observed.isShowingDeleteConfirmation,
            presenting: observed.listPendingDeletion
        ) { shoppingList in
            Button("Отменить", role: .cancel) {
                observed.handleDeleteCancellation()
            }

            Button("Удалить", role: .destructive) {
                observed.handleDeleteConfirmation(
                    shoppingList,
                    modelContext: modelContext
                )
            }
        } message: { _ in
            Text("Вы действительно хотите удалить список?")
        }
        .alert(
            "Не удалось изменить списки",
            isPresented: $observed.isShowingPersistenceError
        ) {
            Button("OK", role: .cancel) {
                observed.handlePersistenceErrorDismissal()
            }
        } message: {
            Text(observed.persistenceErrorMessage ?? "Неизвестная ошибка")
        }
    }

    private var header: some View {
        HStack {
            Text("Мои списки")
                .font(AppTypography.title1Semibold)

            Spacer()

            Button {
            } label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundStyle(.primaryText)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 5)
        .padding(.bottom, 25)
    }

    private var listsView: some View {
        List(shoppingLists) { shoppingList in
            Button {
                observed.handleListTapped(shoppingList)
            } label: {
                ListItemView(shoppingList: shoppingList)
            }
                .buttonStyle(.plain)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        observed.handleDeleteButtonTapped(for: shoppingList)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.deleteAction)

                    Button {
                        observed.handleDuplicate(
                            shoppingList,
                            modelContext: modelContext
                        )
                    } label: {
                        Image(systemName: "doc.on.doc")
                    }
                    .tint(.copyAction)

                    Button {
                        observed.handleEditButtonTapped(for: shoppingList)
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .tint(.editAction)
                }
                .listRowInsets(
                    EdgeInsets(
                        top: 0,
                        leading: 16,
                        bottom: 0,
                        trailing: 16
                    )
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .listRowSpacing(12)
        .scrollContentBackground(.hidden)
        .contentMargins(.top, 0, for: .scrollContent)
    }

    private var createListView: some View {
        CreateEditListView(
            mode: .create,
            existingListNames: shoppingLists.map(\.name)
        ) { draft in
            observed.handleCreate(
                draft,
                modelContext: modelContext
            )
        }
    }

    private func editListView(_ shoppingList: ShoppingList) -> some View {
        CreateEditListView(
            mode: .edit(
                name: shoppingList.name,
                color: shoppingList.color,
                icon: shoppingList.icon
            ),
            existingListNames: shoppingLists.map(\.name)
        ) { draft in
            observed.handleUpdate(
                shoppingList,
                with: draft,
                modelContext: modelContext
            )
        }
    }
}

#Preview("My lists (empty)") {
    NavigationStack {
        MyListsView()
    }
    .modelContainer(for: ShoppingList.self, inMemory: true)
}

#Preview("My lists (data)") {
    NavigationStack {
        MyListsView()
    }
    .modelContainer(makeMyListsPreviewContainer())
}

@MainActor
private func makeMyListsPreviewContainer() -> ModelContainer {
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)

    do {
        let container = try ModelContainer(
            for: ShoppingList.self,
            configurations: configuration
        )
        let shoppingLists = [
            ShoppingList(
                name: "Новый год",
                color: .blue,
                icon: .calendar
            ),
            ShoppingList(
                name: "Кошке",
                color: .green,
                icon: .paw
            ),
            ShoppingList(
                name: "Вечеринка малого",
                color: .yellow,
                icon: .gameController
            )
        ]

        for shoppingList in shoppingLists {
            container.mainContext.insert(shoppingList)
        }

        try container.mainContext.save()
        return container
    } catch {
        fatalError("Не удалось создать ModelContainer для Preview: \(error)")
    }
}
