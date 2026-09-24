//
//  RootView.swift
//  ShoppingList38
//
//  Created by Сергей Хмелёв on 21.09.2026.
//

import SwiftUI

struct RootView: View {
    let appState: AppState

    var body: some View {
        switch appState.route {
        case .welcome:
            WelcomeView {
                appState.handleWelcomeCompletion()
            }
        case .content:
            ContentView()
        }
    }
}

#Preview("Welcome") {
    RootView(
        appState: AppState(
            preferences: PreviewPreferences(hasCompletedWelcome: false)
        )
    )
}

#Preview("Content") {
    RootView(
        appState: AppState(
            preferences: PreviewPreferences(hasCompletedWelcome: true)
        )
    )
}

private final class PreviewPreferences: PreferencesStoring {
    var hasCompletedWelcome: Bool

    init(hasCompletedWelcome: Bool) {
        self.hasCompletedWelcome = hasCompletedWelcome
    }
}
