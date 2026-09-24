//
//  CreateEditItemViewModel.swift
//  ShoppingList38
//
//  Created by Leo Gabuev on 21.09.2026.
//

import SwiftUI

@Observable
final class CreateEditItemViewModel {
    
    enum Mode {
        case create
        case edit
    }
    
    let mode: Mode
    let unit = "шт"
    
    var itemName = ""
    var quantityText = "1"
    
    private var normalizedQuantity: String {
        quantityText.replacingOccurrences(of: ",", with: ".")
    }
    
    var navigationTitle: String {
        mode == .create ? "Создание товара" : "Редактировать"
    }
    
    var isFormValid: Bool {
        let name = itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !name.isEmpty,
              let quantity = Double(normalizedQuantity),
              quantity > 0
        else {
            return false
        }
        
        return true
    }
    
    init(mode: Mode, item: ListItem? = nil) {
        self.mode = mode
        
        guard mode == .edit, let item else {
            return
        }
        
        itemName = item.title
        quantityText = String(item.currentCount)
    }
    
    func saveItem() {
        
        guard let quantity = Double(normalizedQuantity), quantity > 0 else {
            return
        }
    }
}
