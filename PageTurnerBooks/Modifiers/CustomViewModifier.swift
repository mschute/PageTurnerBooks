//
//  SwiftUIView.swift
//  PageTurnerBooks
//
//  Created by Staff on 04/05/2024.
//

import SwiftUI

struct GlobalBackground: ViewModifier {
    var color: Color = .backgroundColor

    func body(content: Content) -> some View {
        content
            .background(color)
            .edgesIgnoringSafeArea(.all)
    }
}

extension View {
    func globalBackground(color: Color = .backgroundColor) -> some View {
        self.modifier(GlobalBackground(color: color))
    }
}

