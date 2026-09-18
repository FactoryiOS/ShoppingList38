//
//  ShoppingItem.swift
//  ShoppingList38
//
//  Created by Сергей Бушков on 17.09.2026.
//

import Foundation

struct ShoppingItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let quantity: Int
    let isPurchased: Bool
}

extension ShoppingItem {
    static let mockNotPurchased = ShoppingItem(
        title: "текст",
        quantity: 2,
        isPurchased: false
    )

    static let mockPurchased = ShoppingItem(
        title: "Чайник",
        quantity: 2,
        isPurchased: true
    )

    static let mock = mockNotPurchased
}
