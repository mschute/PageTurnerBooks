//
//  Flip.swift

import SwiftUI

extension View {
    func flipped(_ axis: Axis = .horizontal, anchor: UnitPoint = .center) -> some View {
        modifier(FlippedViewModifier(axis: axis, anchor: anchor))
    }
}

struct FlippedViewModifier: ViewModifier {
    let axis: Axis
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        switch axis {
        case .horizontal:
            return AnyView(content.scaleEffect(x: -1, y: 1, anchor: anchor))
        case .vertical:
            return AnyView(content.scaleEffect(x: 1, y: -1, anchor: anchor))
        }
    }
}
