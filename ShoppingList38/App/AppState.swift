//
//  AppState.swift
//  ShoppingList38
//
//  Created by Сергей Хмелёв on 20.09.2026.
//

import Observation

enum AppRoute {
    case welcome
    case content
}

@MainActor
@Observable
final class AppState {
    private let preferences: any PreferencesStoring

    private(set) var route: AppRoute

    var currentTheme: AppColorScheme {
        didSet {
            preferences.appTheme = currentTheme
        }
    }

    init(preferences: any PreferencesStoring = PreferencesService()) {
        self.preferences = preferences
        route = preferences.hasCompletedWelcome ? .content : .welcome
        currentTheme = preferences.appTheme
    }

    func handleWelcomeCompletion() {
        preferences.hasCompletedWelcome = true
        route = .content
    }
}
