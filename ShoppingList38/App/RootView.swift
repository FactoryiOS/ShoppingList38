//
//  RootView.swift
//  ShoppingList38
//

import SwiftUI

struct RootView: View {
    let appState: AppState

    var body: some View {
        switch appState.route {
        case .welcome:
            MockWelcomeView {
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
