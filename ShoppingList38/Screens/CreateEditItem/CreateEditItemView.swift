//
//  CreateEditItemView.swift
//  ShoppingList38
//
//  Created by Leo Gabuev on 21.09.2026.
//

import SwiftData
import SwiftUI

struct CreateEditItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var observed: Observed

    private let shoppingList: ShoppingList
    private let item: ShoppingItem?

    init(
        shoppingList: ShoppingList,
        item: ShoppingItem? = nil
    ) {
        self.shoppingList = shoppingList
        self.item = item
        _observed = State(
            initialValue: Observed(item: item)
        )
    }

    var body: some View {
        @Bindable var observed = observed

        VStack(spacing: 20) {
            AppTextField(
                placeholder: "Введите название",
                errorMessage: nil,
                text: $observed.itemName
            )

            HStack(spacing: 16) {
                AppTextField(
                    placeholder: "Количество",
                    errorMessage: nil,
                    text: $observed.quantityText
                )
                .keyboardType(.decimalPad)

                Text(observed.unit)
                    .font(AppTypography.body)
                    .foregroundStyle(.secondary)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 54,
                        alignment: .leading
                    )
                    .padding(.horizontal, 16)
                    .background(.surfaceBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .background(.appBackground)
        .navigationTitle(observed.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Отменить", action: dismiss.callAsFunction)
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Готово", action: handleSave)
                    .disabled(!observed.isFormValid)
                    .fontWeight(.semibold)
            }
        }
        .alert(
            "Не удалось сохранить товар",
            isPresented: $observed.isShowingPersistenceError
        ) {
            Button("OK", role: .cancel) {
                observed.handlePersistenceErrorDismissal()
            }
        } message: {
            Text(observed.persistenceErrorMessage ?? "Неизвестная ошибка")
        }
    }

    private func handleSave() {
        guard observed.handleSave(
            shoppingList: shoppingList,
            item: item,
            modelContext: modelContext
        ) else {
            return
        }

        dismiss()
    }
}

#Preview("Создание") {
    let shoppingList = ShoppingList(
        name: "Новый год",
        color: .blue,
        icon: .calendar
    )

    AppNavigationStack {
        CreateEditItemView(shoppingList: shoppingList)
    }
    .modelContainer(
        for: [ShoppingList.self, ShoppingItem.self],
        inMemory: true
    )
}

#Preview("Редактирование") {
    let shoppingList = ShoppingList(
        name: "Новый год",
        color: .blue,
        icon: .calendar
    )

    AppNavigationStack {
        CreateEditItemView(
            shoppingList: shoppingList,
            item: .mock
        )
    }
    .modelContainer(
        for: [ShoppingList.self, ShoppingItem.self],
        inMemory: true
    )
}
