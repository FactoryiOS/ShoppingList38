//
//  AppState.swift
//  ShoppingList38
//
//  Created by Сергей Хмелёв on 20.09.2026.
//

import Observation

@MainActor
@Observable
final class AppState {
    private let preferences: any PreferencesStoring

    private(set) var shouldShowWelcome: Bool

    init(preferences: any PreferencesStoring = PreferencesService()) {
        self.preferences = preferences
        shouldShowWelcome = !preferences.hasCompletedWelcome
    }

    func handleWelcomeCompletion() {
        preferences.hasCompletedWelcome = true
        shouldShowWelcome = false
    }
}
