//
// CustomMenuStyle

import SwiftUI

struct CustomMenuStyle: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
       Menu(configuration)
            .padding(9)
            .background(Color.white)
            .foregroundColor(Color.pTPrimary)
            .fontWeight(.bold)
            .frame(maxWidth: 250, alignment: .center)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}

#Preview {
    Menu {
        Text("Option 1")
        Text("Option 2")
    } label: {
        Text("Menu Label")
    }
    .menuStyle(CustomMenuStyle())
}
