//
//  CreateEditListView+Observed.swift
//  ShoppingList38
//
//  Created by Сергей Хмелёв on 24.09.2026.
//

import Observation
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

        /// Нормализованные названия существующих списков для проверки дубликатов.
        private let existingListNames: Set<String>

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

        init(
            mode: Mode,
            existingListNames: [String]
        ) {
            self.mode = mode
            self.existingListNames = Set(
                existingListNames.map(Self.normalize)
            )

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

        func handleSave() -> ListDraft? {
            guard isFormComplete,
                  let selectedColor,
                  let selectedIcon
            else {
                return nil
            }

            guard !isDuplicateName else {
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
        private var isDuplicateName: Bool {
            let normalizedName = Self.normalize(trimmedListName)

            if let originalListName,
               normalizedName == Self.normalize(originalListName) {
                return false
            }

            return existingListNames.contains(normalizedName)
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
