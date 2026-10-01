//
//  WelcomeView.swift
//  ShoppingList38
//
//  Created by el on 21.09.2026.
//

import SwiftUI

struct WelcomeView: View {

    let onStart: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)

            VStack(spacing: 0) {
                Text("Добро пожаловать!")
                    .font(AppTypography.largeTitleSemibold)
                    .foregroundStyle(.primaryText)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)

                Image(.welcome)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 32)
                    .padding(.top, 32)

                VStack(spacing: 8) {
                    Text("Никогда не забывайте,\nчто нужно купить")
                        .font(AppTypography.title2Semibold)
                        .foregroundStyle(.primaryText)

                    Text("Создавайте списки\nи не переживайте о покупках")
                        .font(AppTypography.body)
                        .foregroundStyle(.listSecondaryText)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.top, 24)
            }

            Spacer(minLength: 0)

            AppButton(title: "Начать", isActive: true) {
                onStart()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground.ignoresSafeArea())
    }
}

#Preview("Light") {
    WelcomeView { }
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    WelcomeView { }
        .preferredColorScheme(.dark)
}
