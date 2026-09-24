//
//  CreateEditListView.swift
//  ShoppingList38
//
//  Created by Сергей Хмелёв on 24.09.2026.
//

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

    /// Наблюдаемое состояние и логика формы.
    @State private var observed: Observed

    /// Обработчик, которому передаются данные списка после сохранения.
    private let onSave: (ListDraft) -> Void

    init(
        mode: Mode,
        existingListNames: [String] = [],
        onSave: @escaping (ListDraft) -> Void = { _ in }
    ) {
        _observed = State(
            initialValue: Observed(
                mode: mode,
                existingListNames: existingListNames
            )
        )
        self.onSave = onSave
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
            .padding(.vertical, 8)
            .background(Color.appBackground)
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
        guard let draft = observed.handleSave() else {
            return
        }

        onSave(draft)
        dismiss()
    }
}

#Preview("Создание (Light mode)") {
    NavigationStack {
        CreateEditListView(
            mode: .create,
            existingListNames: ["Новый год"]
        )
    }
    .preferredColorScheme(.light)
}

#Preview("Создание (Dark mode)") {
    NavigationStack {
        CreateEditListView(
            mode: .create,
            existingListNames: ["Новый год"]
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Редактирование (Light mode)") {
    NavigationStack {
        CreateEditListView(
            mode: .edit(
                name: "Новый год",
                color: .blue,
                icon: .snowflake
            )
        )
    }
    .preferredColorScheme(.light)
}

#Preview("Редактирование (Dark Mode)") {
    NavigationStack {
        CreateEditListView(
            mode: .edit(
                name: "Новый год",
                color: .blue,
                icon: .snowflake
            )
        )
    }
    .preferredColorScheme(.dark)
}
