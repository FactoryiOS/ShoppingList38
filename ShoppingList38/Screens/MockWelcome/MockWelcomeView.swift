//
//  MockWelcomeView.swift
//  ShoppingList38
//

import SwiftUI

struct MockWelcomeView: View {
    private let onCompletion: @MainActor () -> Void

    init(onCompletion: @escaping @MainActor () -> Void) {
        self.onCompletion = onCompletion
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("Добро пожаловать!")
                .font(AppTypography.largeTitleRegular)
                .foregroundStyle(Color("PrimaryText"))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)

            Image("WelcomeImage")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 280, maxHeight: 286)
                .accessibilityHidden(true)
                .padding(.top, 48)

            Text("Никогда не забывайте,\nчто нужно купить")
                .font(AppTypography.title3Semibold)
                .foregroundStyle(Color("PrimaryText"))
                .multilineTextAlignment(.center)
                .padding(.top, 50)

            Text("Создавайте списки\nи не переживайте о покупках")
                .font(AppTypography.body)
                .foregroundStyle(Color("PrimaryText"))
                .multilineTextAlignment(.center)
                .padding(.top, 14)

            Spacer(minLength: 20)

            Button {
                onCompletion()
            } label: {
                Text("Начать")
                    .font(AppTypography.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color("PrimaryAction"))
                    .clipShape(.capsule)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.top, 31)
        .padding(.bottom, 19)
        .background(Color("AppBackground").ignoresSafeArea())
    }
}

#Preview {
    MockWelcomeView(onCompletion: {})
}
