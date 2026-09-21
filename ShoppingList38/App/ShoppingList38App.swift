//
//  ShoppingList38App.swift
//  ShoppingList38
//
//  Created by Nikita Tsomuk on 07.09.2026.
//

import SwiftUI

@main
struct ShoppingList38App: App {
    @State private var appState: AppState

    init() {
        let preferences = PreferencesService(storage: .standard)
        _appState = State(
            initialValue: AppState(preferences: preferences)
        )
    }

    var body: some Scene {
        WindowGroup {
            RootView(appState: appState)
        }
    }
}
