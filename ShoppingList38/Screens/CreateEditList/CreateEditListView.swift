//
//  CreateEditListView.swift
//  ShoppingList38
//
//  Created by Сергей Хмелёв on 24.09.2026.
//

import SwiftData
import SwiftUI

struct CreateEditListView: View {
    /// Режим работы экрана: создание нового или редактирование существующего списка.
    enum Mode {
        case create
        case edit(
            name: String,
            color: ListColor,
            icon: ListIcon
        )
    }

    /// Данные списка, собранные из формы после успешной валидации.
    struct ListDraft {
        /// Название списка без пробелов по краям.
        let name: String

        /// Выбранный цвет списка.
        let color: ListColor

        /// Выбранная иконка списка.
        let icon: ListIcon
    }

    /// Системное действие закрытия текущего экрана.
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \ShoppingList.createdAt, order: .reverse)
    private var shoppingLists: [ShoppingList]

    /// Наблюдаемое состояние и логика формы.
    @State private var observed: Observed

    /// Редактируемый список; `nil` в режиме создания.
    private let shoppingList: ShoppingList?

    init(shoppingList: ShoppingList? = nil) {
        self.shoppingList = shoppingList

        let mode: Mode

        if let shoppingList {
            mode = .edit(
                name: shoppingList.name,
                color: shoppingList.color,
                icon: shoppingList.icon
            )
        } else {
            mode = .create
        }

        _observed = State(
            initialValue: Observed(mode: mode)
        )
    }

    var body: some View {
        @Bindable var observed = observed

        VStack(spacing: 0) {
            navigationHeader

            ScrollView {
                VStack(spacing: 24) {
                    AppTextField(
                        placeholder: "Введите название списка",
                        errorMessage: observed.nameErrorMessage,
                        text: $observed.listName
                    )

                    ColorSelectorView(
                        title: "Выберите цвет",
                        selectedColor: $observed.selectedColor
                    )

                    IconSelectorView(
                        title: "Выберите дизайн",
                        selectionColor: observed.iconSelectionColor,
                        selectedIcon: $observed.selectedIcon
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 16)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .bottom) {
            AppButton(
                title: observed.actionTitle,
                isActive: observed.isFormComplete,
                action: handleSave
            )
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 20)
            .background(Color.appBackground)
        }
        .alert(
            "Не удалось сохранить список",
            isPresented: $observed.isShowingPersistenceError
        ) {
            Button("OK", role: .cancel) {
                observed.handlePersistenceErrorDismissal()
            }
        } message: {
            Text(observed.persistenceErrorMessage ?? "Неизвестная ошибка")
        }
    }

    private var navigationHeader: some View {
        HStack(spacing: 0) {
            Button(action: dismiss.callAsFunction) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.primary)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Назад")

            Text(observed.navigationTitle)
                .font(AppTypography.title3Semibold)
                .foregroundStyle(.primary)

            Spacer()
        }
        .padding(.horizontal, 8)
    }

    private func handleSave() {
        guard observed.handleSave(
            shoppingList: shoppingList,
            existingListNames: shoppingLists.map(\.name),
            modelContext: modelContext
        ) else {
            return
        }

        dismiss()
    }
}

#Preview("Создание (Light mode)") {
    AppNavigationStack {
        CreateEditListView()
    }
    .modelContainer(
        for: [ShoppingList.self, ShoppingItem.self],
        inMemory: true
    )
    .preferredColorScheme(.light)
}

#Preview("Создание (Dark mode)") {
    AppNavigationStack {
        CreateEditListView()
    }
    .modelContainer(
        for: [ShoppingList.self, ShoppingItem.self],
        inMemory: true
    )
    .preferredColorScheme(.dark)
}

#Preview("Редактирование (Light mode)") {
    let shoppingList = ShoppingList(
        name: "Новый год",
        color: .blue,
        icon: .snowflake
    )

    AppNavigationStack {
        CreateEditListView(shoppingList: shoppingList)
    }
    .modelContainer(
        for: [ShoppingList.self, ShoppingItem.self],
        inMemory: true
    )
    .preferredColorScheme(.light)
}

#Preview("Редактирование (Dark Mode)") {
    let shoppingList = ShoppingList(
        name: "Новый год",
        color: .blue,
        icon: .snowflake
    )

    AppNavigationStack {
        CreateEditListView(shoppingList: shoppingList)
    }
    .modelContainer(
        for: [ShoppingList.self, ShoppingItem.self],
        inMemory: true
    )
    .preferredColorScheme(.dark)
}
