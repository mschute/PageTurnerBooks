//
//  DisabledButtonStyle.swift
//  PageTurnerBooks
//
//  Created by Staff on 08/05/2024.
//

import SwiftUI

struct DisabledButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .bold, design: .default))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.gray]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .foregroundColor(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            .frame(minWidth: 100, minHeight: 50, maxHeight: 50, alignment: .center)
    }
}
