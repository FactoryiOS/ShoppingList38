//
//  MyListsView.swift
//  ShoppingList38
//
//  Created by el on 23.09.2026.
//

import SwiftUI

struct MyListsView: View {
    
    let items: [ListItem]
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Text("Мои списки")
                    .font(AppTypography.title1Semibold)
                
                Spacer()
                
                Button {
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(.primaryText)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 5)
            .padding(.bottom, 25)
            
            if items.isEmpty {
                EmptyStateView(
                    imageName: "EmptyListsImage",
                    title: "Давайте спланируем покупки!",
                    subtitle: "Создайте свой первый список",
                    imageSize: 277
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else {
                List(items) { item in
                    ListItemView(item: item)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                print("Удалить \(item.title)")
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.deleteAction)
                            
                            Button {
                                print("Копировать \(item.title)")
                            } label: {
                                Image(systemName: "doc.on.doc")
                            }
                            .tint(.copyAction)
                            
                            Button {
                                print("Редактировать \(item.title)")
                            } label: {
                                Image(systemName: "square.and.pencil")
                            }
                            .tint(.disabledButton)
                        }
                    
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .listRowSpacing(12)
                .scrollContentBackground(.hidden)
                .contentMargins(.top, 0, for: .scrollContent)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            AppButton(title: "Создать список", isActive: true) {
                print("Создать список")
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(.appBackground)
    }
}

#Preview("Empty") {
    MyListsView(items: [])
}

#Preview("Data") {
    MyListsView(items: ListItem.mocks)
}

