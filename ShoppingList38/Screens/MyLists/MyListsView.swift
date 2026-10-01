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
    @Environment(AppRouter.self) private var router
    @Environment(AppState.self) private var appState

    @Query(sort: \ShoppingList.createdAt, order: .reverse)
    private var shoppingLists: [ShoppingList]

    @State private var observed = Observed()

    private var displayedShoppingLists: [ShoppingList] {
        observed.sortedLists(shoppingLists)
    }

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
                observed.handleCreateButtonTapped(router: router)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(.appBackground)
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

            Menu {
                Picker(
                    "Установить тему",
                    systemImage: "circle.lefthalf.filled.inverse",
                    selection: Binding(
                        get: { appState.currentTheme },
                        set: { appState.currentTheme = $0 }
                    )
                ) {
                    ForEach(AppColorScheme.allCases) { scheme in
                        Text(scheme.displayName)
                            .tag(scheme)
                    }
                }
                .pickerStyle(.menu)

                Divider()

                Button {
                    observed.handleAlphabeticalSortTapped()
                } label: {
                    Label(
                        "Сортировать по алфавиту",
                        systemImage: observed.isSortedAlphabetically
                            ? "checkmark"
                            : "arrow.up.arrow.down"
                    )
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 24))
                    .foregroundStyle(.primaryText)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 5)
        .padding(.bottom, 25)
    }

    private var listsView: some View {
        List(displayedShoppingLists) { shoppingList in
            Button {
                router.push(.shoppingList(id: shoppingList.id))
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
                        observed.handleEditButtonTapped(
                            for: shoppingList,
                            router: router
                        )
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
}

#Preview("My lists (empty)") {
    let appState = AppState()

    AppNavigationStack {
        MyListsView()
    }
    .environment(appState)
    .preferredColorScheme(appState.currentTheme.colorScheme)
    .modelContainer(
        for: [ShoppingList.self, ShoppingItem.self],
        inMemory: true
    )
}

#Preview("My lists (data)") {
    let appState = AppState()

    AppNavigationStack {
        MyListsView()
    }
    .environment(appState)
    .preferredColorScheme(appState.currentTheme.colorScheme)
    .modelContainer(makeMyListsPreviewContainer())
}

@MainActor
private func makeMyListsPreviewContainer() -> ModelContainer {
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)

    do {
        let container = try ModelContainer(
            for: ShoppingList.self, ShoppingItem.self,
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
