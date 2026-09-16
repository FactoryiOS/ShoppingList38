//
//  AppTextField.swift
//  ShoppingList38
//
//  Created by Leo Gabuev on 14.09.2026.
//

import SwiftUI

struct AppTextField: View {
    
    let placeholder: String
    let errorMessage: String?
    
    @Binding var text: String
    
    private var hasError: Bool {
        errorMessage != nil
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                TextField(placeholder, text: $text)
                
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(.disabledButtonText)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 54)
            .background(.surfaceBackground)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        hasError ? .deleteAction : Color.clear,
                        lineWidth: hasError ? 0.5 : 0
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            if let errorMessage {
                Text(errorMessage)
                    .font(AppTypography.footnoteRegular)
                    .foregroundStyle(.deleteAction)
                    .padding(.horizontal, 8)
            }
        }
    }
}

#Preview("Default (Empty)") {
    AppTextField(
        placeholder: "Введите название списка",
        errorMessage: nil,
        text: .constant("")
    )
    .padding()
    .background(.appBackground)
    
}

#Preview("With Text & Clear Button") {
    AppTextField(
        placeholder: "Название списка",
        errorMessage: nil,
        text: .constant("Мои продукты")
    )
    .padding()
    .background(.appBackground)
}

#Preview("Error State") {
    AppTextField(
        placeholder: "Название списка",
        errorMessage: "Это название уже используется, пожалуйста, измените его.",
        text: .constant("Существующее имя")
    )
    .padding()
    .background(.appBackground)
}
