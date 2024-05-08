//
//  PrimaryButtonStyle.swift
//  PageTurnerBooks
//
//  Created by Staff on 07/05/2024.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .bold, design: .default))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.pTPrimary)
//            .background(LinearGradient(gradient: Gradient(colors: [Color.pTPrimary.opacity(0.8), Color.pTPrimary]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .foregroundColor(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            .frame(minWidth: 100, minHeight: 50, maxHeight: 50, alignment: .center)
    }
}

