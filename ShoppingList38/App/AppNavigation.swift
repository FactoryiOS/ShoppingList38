//
//  AppNavigation.swift
//  ShoppingList38
//
//  Created by Сергей Бушков on 29.09.2026.
//

import Observation
import SwiftUI

enum AppDestination: Hashable, Identifiable {
    case shoppingList(ListItem)
    case createList
    case createItem

    var id: Self { self }
}

@MainActor
@Observable
final class AppRouter {
    fileprivate(set) var path: [AppDestination] = []
    fileprivate(set) var presentedModal: AppDestination?

    func push(_ destination: AppDestination) {
        path.append(destination)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    func showModal(_ destination: AppDestination) {
        presentedModal = destination
    }
}

struct AppNavigationStack<Content: View>: View {
    @State private var router = AppRouter()

    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: AppDestination.self) { destination in
                    AppDestinationView(destination: destination)
                }
        }
        .sheet(item: $router.presentedModal) { destination in
            AppDestinationView(destination: destination)
                .environment(router)
        }
        .environment(router)
    }
}

private struct AppDestinationView: View {
    let destination: AppDestination

    var body: some View {
        switch destination {
        case .shoppingList(let listItem):
            ShoppingListView(listTitle: listItem.title)
        case .createList:
            CreateEditListView(
                mode: .create,
                existingListNames: ListItem.mocks.map(\.title),
                onSave: { _ in true }
            )
        case .createItem:
            CreateEditItemView(mode: .create)
        }
    }
}
