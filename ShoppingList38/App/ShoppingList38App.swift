//
//  ShoppingList38App.swift
//  ShoppingList38
//
//  Created by Nikita Tsomuk on 07.09.2026.
//

import SwiftUI

@main
struct ShoppingList38App: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            Group {
                if appState.shouldShowWelcome {
                    MockWelcomeView {
                        appState.handleWelcomeCompletion()
                    }
                } else {
                    ContentView()
                }
            }
        }
    }
}
