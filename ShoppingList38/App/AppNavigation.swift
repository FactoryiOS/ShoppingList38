//
//  AppNavigation.swift
//  ShoppingList38
//
//  Created by Сергей Хмелёв on 27.09.2026.
//

import Observation
import SwiftUI

enum AppDestination: Hashable {
    case createList
    case editList(ShoppingList)
    case shoppingList(ShoppingList)
    case createItem(shoppingList: ShoppingList)
    case editItem(shoppingList: ShoppingList, item: ShoppingItem)
}

@MainActor
@Observable
final class AppRouter {
    var path: [AppDestination] = []

    func navigate(to destination: AppDestination) {
        path.append(destination)
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
        .environment(router)
    }
}

private struct AppDestinationView: View {
    let destination: AppDestination

    @ViewBuilder
    var body: some View {
        switch destination {
        case .createList:
            CreateEditListView()
        case .editList(let shoppingList):
            CreateEditListView(shoppingList: shoppingList)
        case .shoppingList(let shoppingList):
            ShoppingListView(shoppingList: shoppingList)
        case .createItem(let shoppingList):
            CreateEditItemView(shoppingList: shoppingList)
        case let .editItem(shoppingList, item):
            CreateEditItemView(
                shoppingList: shoppingList,
                item: item
            )
        }
    }
}
