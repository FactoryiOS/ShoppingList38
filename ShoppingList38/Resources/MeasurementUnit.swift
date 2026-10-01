//
//  MeasurementUnit.swift
//  ShoppingList38
//
//  Created by Сергей Бушков on 30.09.2026.
//

import Foundation

enum MeasurementUnit: String, CaseIterable, Identifiable {
    case pieces = "шт"
    case kilograms = "кг"
    case grams = "г"
    case liters = "л"
    case milliliters = "мл"

    var id: Self { self }

    var title: String {
        rawValue
    }

    static func from(storedValue: String) -> MeasurementUnit {
        let normalized = storedValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "."))

        return MeasurementUnit(rawValue: normalized) ?? .pieces
    }
}
