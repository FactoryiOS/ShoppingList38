//
//  WelcomeView.swift
//  ShoppingList38
//
//  Created by el on 21.09.2026.
//

import SwiftUI

struct WelcomeView: View {
    
    let onStart: () -> Void
    
    var  body: some View {
        VStack {
            Text("Добро пожаловать!")
                .font(AppTypography.largeTitleRegular)
                .padding(.top, 32)
            
            Image(.welcome)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 330)
                .padding(.top, 52)
            
            Spacer()
            
            VStack(spacing: 16) {
                Text("Никогда не забывайте, \nчто нужно купить")
                    .font(AppTypography.title2semibold)
                    .multilineTextAlignment(.center)
                
                Text("Создавайте списки \nи не переживайте о покупках")
                    .font(AppTypography.body)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            AppButton(title: "Начать", isActive: true) {
                onStart()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    WelcomeView {
        print("Начать")
    }
}
