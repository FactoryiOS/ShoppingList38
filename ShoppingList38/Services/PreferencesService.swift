//
//  PreferencesService.swift
//  ShoppingList38
//
//  Created by Сергей Хмелёв on 20.09.2026.
//

import Foundation

protocol PreferencesStoring: AnyObject {
    var hasCompletedWelcome: Bool { get set }
    var appTheme: AppColorScheme { get set }
}

final class PreferencesService: PreferencesStoring {
    private enum Keys {
        static let hasCompletedWelcomeKey = "appState.hasCompletedWelcome"
        static let appThemeKey = "appState.themePreference"
    }

    private let storage: UserDefaults

    init(storage: UserDefaults = .standard) {
        self.storage = storage
    }

    var hasCompletedWelcome: Bool {
        get {
            storage.bool(forKey: Keys.hasCompletedWelcomeKey)
        }
        set {
            storage.set(newValue, forKey: Keys.hasCompletedWelcomeKey)
        }
    }
    
    var appTheme: AppColorScheme {
        get {
            guard let rawValue = storage.string(forKey: Keys.appThemeKey),
                  let scheme = AppColorScheme(rawValue: rawValue) else {
                return .system 
            }
            return scheme
        }
        set {
            storage.set(newValue.rawValue, forKey: Keys.appThemeKey)
        }
    }
}
