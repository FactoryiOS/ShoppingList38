//
//  PreferencesService.swift
//  ShoppingList38
//
//  Created by Сергей Хмелёв on 20.09.2026.
//

import Foundation

protocol PreferencesStoring: AnyObject {
    var hasCompletedWelcome: Bool { get set }
}

final class PreferencesService: PreferencesStoring {
    private enum Keys {
        static let hasCompletedWelcomeKey = "appState.hasCompletedWelcome"
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
}
