//
//  PTTextFieldStyle.swift
//  PageTurnerBooks
//
//  Created by Staff on 07/05/2024.
//

import SwiftUI

struct PTTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View{
        content
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 0.5)
        )
    }
}

extension View {
    func pTTextFieldStyle() -> some View {
        self.modifier(PTTextFieldStyle())
    }
}
