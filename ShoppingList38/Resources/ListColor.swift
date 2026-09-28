//
//  ListColor.swift
//  ShoppingList38
//
//  Created by AntonA22 on 15.09.2026.
//

import SwiftUI

// Raw values are persisted identifiers and must stay stable when cases are renamed.
// swiftlint:disable redundant_string_enum_value
enum ListColor: String, CaseIterable, Identifiable {

    case blue = "blue"
    case green = "green"
    case purple = "purple"
    case red = "red"
    case yellow = "yellow"

    var id: String {
        rawValue
    }

    var assetName: String {
        switch self {
        case .blue: "ListColorBlue"
        case .green: "ListColorGreen"
        case .purple: "ListColorPurple"
        case .red: "ListColorRed"
        case .yellow: "ListColorYellow"
        }
    }

    var color: Color {
        Color(assetName)
    }
}
// swiftlint:enable redundant_string_enum_value
