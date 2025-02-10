//
//  GameAlertsModifier.swift
//  Wordle
//
//  Created by Даниил Иваньков on 07.02.2025.
//

import SwiftUI

struct GameAlertsModifier: ViewModifier {
    var isAlertsShow: Bool
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.white.opacity(0.8))
            .opacity(isAlertsShow ? 1 : 0)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .animation(.spring, value: isAlertsShow)
            .offset(y: 150)
    }
}

extension View {
    func showAlerts(_ alerts: Bool) -> some View {
        modifier(GameAlertsModifier(isAlertsShow: alerts))
    }
}
