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
            Text("Добро пожаловать!")
                .font(AppTypography.largeTitleRegular)
                .foregroundStyle(.primaryText)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            
            Image(.welcome)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 49)
                .padding(.top, 48)
                .padding(.bottom, 48)
            
            VStack(spacing: 16) {
                Text("Никогда не забывайте,\nчто нужно купить")
                    .font(AppTypography.title2semibold)
                    .foregroundStyle(.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Создавайте списки\nи не переживайте о покупках")
                    .font(AppTypography.body)
                    .foregroundStyle(.primaryText)
                    .multilineTextAlignment(.center)
            }
            
            .padding(.horizontal, 16)
            
            Spacer()
            
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
