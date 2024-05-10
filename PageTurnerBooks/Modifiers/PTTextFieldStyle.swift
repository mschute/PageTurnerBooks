//
//  PTTextFieldStyle.swift

import SwiftUI

struct PTTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View{
        content
            .padding(10)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 0.5)
        )
    }
}

extension View {
    func pTTextFieldStyle() -> some View {
        self.modifier(PTTextFieldStyle())
    }
}
