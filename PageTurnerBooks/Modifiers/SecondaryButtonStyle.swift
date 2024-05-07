//
//  SecondaryButtonStyle.swift
//  PageTurnerBooks
//
//  Created by Staff on 07/05/2024.
//

import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .bold, design: .default))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.8), Color.green]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .foregroundColor(Color.white)
            .font(.system(size: 20, weight: .bold, design: .default))
            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            .frame(minWidth: 100, minHeight: 50, maxHeight: 50, alignment: .center)
    }
}
