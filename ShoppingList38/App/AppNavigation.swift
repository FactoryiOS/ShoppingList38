//
//  AppNavigation.swift
//  ShoppingList38
//
//  Created by Сергей Хмелёв on 27.09.2026.
//

import Observation
import SwiftData
import SwiftUI

enum AppDestination: Hashable {
    case createList
    case editList(id: UUID)
    case shoppingList(id: UUID)
    case createItem(shoppingListID: UUID)
    case editItem(shoppingListID: UUID, itemID: UUID)
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
        case .editList(let id):
            ShoppingListDestination(id: id) { shoppingList in
                CreateEditListView(shoppingList: shoppingList)
            }
        case .shoppingList(let id):
            ShoppingListDestination(id: id) { shoppingList in
                ShoppingListView(shoppingList: shoppingList)
            }
        case .createItem(let shoppingListID):
            ShoppingListDestination(id: shoppingListID) { shoppingList in
                CreateEditItemView(shoppingList: shoppingList)
            }
        case let .editItem(shoppingListID, itemID):
            ShoppingListDestination(id: shoppingListID) { shoppingList in
                ShoppingItemDestination(id: itemID, shoppingListID: shoppingListID) { item in
                    CreateEditItemView(shoppingList: shoppingList, item: item)
                }
            }
        }
    }
}

private struct ShoppingListDestination<Content: View>: View {
    @Query private var shoppingLists: [ShoppingList]

    let content: (ShoppingList) -> Content

    init(id: UUID, @ViewBuilder content: @escaping (ShoppingList) -> Content) {
        _shoppingLists = Query(filter: #Predicate<ShoppingList> { $0.id == id })
        self.content = content
    }

    var body: some View {
        if let shoppingList = shoppingLists.first {
            content(shoppingList)
        } else {
            MissingDestinationView(title: "Список не найден")
        }
    }
}

private struct ShoppingItemDestination<Content: View>: View {
    @Query private var items: [ShoppingItem]

    let content: (ShoppingItem) -> Content

    init(
        id: UUID,
        shoppingListID: UUID,
        @ViewBuilder content: @escaping (ShoppingItem) -> Content
    ) {
        _items = Query(filter: #Predicate<ShoppingItem> { item in
            item.id == id && item.shoppingList?.id == shoppingListID
        })
        self.content = content
    }

    var body: some View {
        if let item = items.first {
            content(item)
        } else {
            MissingDestinationView(title: "Товар не найден")
        }
    }
}

private struct MissingDestinationView: View {
    @Environment(AppRouter.self) private var router

    let title: String

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: "exclamationmark.circle")
        } description: {
            Text("Возможно, он был удалён.")
        } actions: {
            Button("Мои списки") {
                router.path.removeAll()
            }
        }
    }
}
