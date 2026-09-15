//
//  ListColor.swift
//  ShoppingList38
//
//  Created by AntonA22 on 15.09.2026.
//

import SwiftUI

enum ListColor: String, CaseIterable, Identifiable {

    case blue = "ListColorBlue"
    case green = "ListColorGreen"
    case purple = "ListColorPurple"
    case red = "ListColorRed"
    case yellow = "ListColorYellow"

    var id: String {
        rawValue
    }

    var color: Color {
        Color(rawValue)
    }
}
