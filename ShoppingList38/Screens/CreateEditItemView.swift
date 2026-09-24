//
//  CreateEditItemView.swift
//  ShoppingList38
//
//  Created by Leo Gabuev on 21.09.2026.
//

import SwiftUI

struct CreateEditItemView: View {
    
    @State private var viewModel: CreateEditItemViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(mode: CreateEditItemViewModel.Mode, item: ListItem? = nil) {
        _viewModel = State(
            initialValue: CreateEditItemViewModel(mode: mode, item: item)
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                AppTextField(
                    placeholder: "Введите название",
                    errorMessage: nil,
                    text: $viewModel.itemName
                )
                
                HStack(spacing: 16) {
                    AppTextField(
                        placeholder: "Количество",
                        errorMessage: nil,
                        text: $viewModel.quantityText
                    )
                    .keyboardType(.decimalPad)
                    
                    Text(viewModel.unit)
                        .font(AppTypography.body)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, minHeight: 54, alignment: .leading)
                        .padding(.horizontal, 16)
                        .background(.surfaceBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .background(.appBackground)
            
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отменить") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") {
                        viewModel.saveItem()
                        dismiss()
                    }
                    .disabled(!viewModel.isFormValid)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview("Создание") {
    CreateEditItemView(mode: .create)
}

#Preview("Редактирование") {
    CreateEditItemView(mode: .edit, item: ListItem.mock)
}

#Preview("Dark Mode - Create") {
    CreateEditItemView(mode: .create)
        .environment(\.colorScheme, .dark)
}

#Preview("Dark Mode - Edit") {
    CreateEditItemView(mode: .edit, item: ListItem.mock)
        .environment(\.colorScheme, .dark)
}
