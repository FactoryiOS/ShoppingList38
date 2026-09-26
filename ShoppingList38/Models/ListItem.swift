//
//  ListItem.swift
//  ShoppingList38
//
//  Created by Leo Gabuev on 15.09.2026.
//

import SwiftUI

struct ListItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let icon: ListIcon
    let iconColor: Color
    let currentCount: Int
    let totalCount: Int
    
    var progressText: String {
        "\(currentCount)/\(totalCount)"
    }
}

extension ListItem {
    static let mock = ListItem(
        title: "Новый год",
        icon: .calendar,
        iconColor: Color(.listColorBlue),
        currentCount: 10,
        totalCount: 20
    )
}

// Моки для списка

extension ListItem {
    
    static let mocks: [ListItem] = [
        mock,
        
        ListItem(
            title: "Кошке",
            icon: .paw,
            iconColor: ListColor.green.color,
            currentCount: 1,
            totalCount: 4
        ),
        
        ListItem(
            title: "Вечеринка малого",
            icon: .gameController,
            iconColor: ListColor.yellow.color,
            currentCount: 9,
            totalCount: 20
        )
    ]
}
