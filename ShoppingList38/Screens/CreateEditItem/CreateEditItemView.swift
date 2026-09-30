//
//  CreateEditItemView.swift
//  ShoppingList38
//
//  Created by Leo Gabuev on 21.09.2026.
//

import SwiftData
import SwiftUI

struct CreateEditItemView: View {
    @Environment(AppRouter.self) private var router
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

                unitPicker
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
                Button("Отменить", action: router.dismiss)
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

        router.dismiss()
    }

    private var unitPicker: some View {
        Menu {
            Picker("Ед.изм.", selection: $observed.unit) {
                ForEach(MeasurementUnit.allCases) { unit in
                    Text(unit.title)
                        .tag(unit)
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text("Ед. изм.:")
                    .font(AppTypography.body)
                    .foregroundStyle(.listSecondaryText)

                Spacer(minLength: 0)

                Text(observed.unit.title)
                    .font(AppTypography.body)
                    .foregroundStyle(.primaryAction)

                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.primaryAction)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, minHeight: 54)
            .background(.surfaceBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Единица измерения")
        .accessibilityValue(observed.unit.title)
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
