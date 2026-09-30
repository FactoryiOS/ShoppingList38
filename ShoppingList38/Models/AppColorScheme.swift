//
//  AppColorScheme.swift
//  ShoppingList38
//
//  Created by Leo Gabuev on 30.09.2026.
//

import SwiftUI

enum AppColorScheme: String, CaseIterable, Identifiable {
    case light
    case dark
    case system
    
    var id: Self { self }
    
    var displayName: String {
        switch self {
        case .light: "Светлая"
        case .dark: "Темная"
        case .system: "Системная"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light: .light
        case .dark: .dark
        case .system: nil
        }
    }
}
