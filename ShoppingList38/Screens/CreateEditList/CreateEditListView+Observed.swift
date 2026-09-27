//
//  CreateEditListView+Observed.swift
//  ShoppingList38
//
//  Created by Сергей Хмелёв on 24.09.2026.
//

import Observation
import SwiftData
import SwiftUI

extension CreateEditListView {
    @Observable
    final class Observed {
        /// Текущий режим работы экрана.
        let mode: Mode

        /// Введённое пользователем название списка.
        var listName: String {
            didSet {
                if listName != oldValue {
                    nameErrorMessage = nil
                }
            }
        }

        /// Выбранный цвет списка; `nil`, пока цвет не выбран.
        var selectedColor: ListColor?

        /// Выбранная иконка списка; `nil`, пока иконка не выбрана.
        var selectedIcon: ListIcon?

        /// Текст ошибки названия, отображаемый под полем ввода.
        private(set) var nameErrorMessage: String?

        /// Текст ошибки сохранения списка.
        private(set) var persistenceErrorMessage: String?

        /// Исходное название редактируемого списка; позволяет сохранить его без смены имени.
        private let originalListName: String?

        /// Заголовок экрана, соответствующий текущему режиму.
        var navigationTitle: String {
            switch mode {
            case .create:
                "Создать список"
            case .edit:
                "Редактировать список"
            }
        }

        /// Текст основной кнопки, соответствующий текущему режиму.
        var actionTitle: String {
            switch mode {
            case .create:
                "Создать"
            case .edit:
                "Сохранить"
            }
        }

        /// Цвет фона выбранной иконки.
        var iconSelectionColor: Color {
            selectedColor?.color ?? .listColorBlue
        }

        /// Признак того, что все обязательные поля формы заполнены.
        var isFormComplete: Bool {
            !trimmedListName.isEmpty &&
            selectedColor != nil &&
            selectedIcon != nil
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

        init(mode: Mode) {
            self.mode = mode

            switch mode {
            case .create:
                listName = ""
                selectedColor = nil
                selectedIcon = nil
                originalListName = nil
            case let .edit(name, color, icon):
                listName = name
                selectedColor = color
                selectedIcon = icon
                originalListName = name
            }
        }

        func handleSave(
            shoppingList: ShoppingList?,
            existingListNames: [String],
            modelContext: ModelContext
        ) -> Bool {
            guard let draft = makeDraft(
                existingListNames: existingListNames
            ) else {
                return false
            }

            do {
                let store = ShoppingListStore(modelContext: modelContext)

                if let shoppingList {
                    try store.update(
                        shoppingList,
                        name: draft.name,
                        color: draft.color,
                        icon: draft.icon
                    )
                } else {
                    _ = try store.create(
                        name: draft.name,
                        color: draft.color,
                        icon: draft.icon
                    )
                }

                return true
            } catch {
                persistenceErrorMessage = error.localizedDescription
                return false
            }
        }

        func handlePersistenceErrorDismissal() {
            persistenceErrorMessage = nil
        }

        private func makeDraft(
            existingListNames: [String]
        ) -> ListDraft? {
            guard isFormComplete,
                  let selectedColor,
                  let selectedIcon
            else {
                return nil
            }

            guard !isDuplicateName(in: existingListNames) else {
                nameErrorMessage = "Это название уже используется, пожалуйста, измените его."
                return nil
            }

            return ListDraft(
                name: trimmedListName,
                color: selectedColor,
                icon: selectedIcon
            )
        }

        /// Название списка без пробелов и переносов строк по краям.
        private var trimmedListName: String {
            listName.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        /// Признак совпадения введённого названия с другим списком.
        private func isDuplicateName(
            in existingListNames: [String]
        ) -> Bool {
            let normalizedName = Self.normalize(trimmedListName)

            if let originalListName,
               normalizedName == Self.normalize(originalListName) {
                return false
            }

            return existingListNames
                .map(Self.normalize)
                .contains(normalizedName)
        }

        private static func normalize(_ name: String) -> String {
            name
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .folding(
                    options: [.caseInsensitive, .diacriticInsensitive],
                    locale: .current
                )
        }
    }
}
