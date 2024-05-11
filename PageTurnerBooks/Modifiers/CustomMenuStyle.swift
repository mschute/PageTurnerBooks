//
//  CustomMenuStyle.swift
//  PageTurnerBooks
//
//  Created by Staff on 11/05/2024.
//

import SwiftUI

struct CustomMenuStyle: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
       Menu(configuration)
        //configuration.label
            //.frame(maxWidth: .infinity, alignment: .leading)
            .padding(6)
            .background(.white, in: RoundedRectangle(cornerRadius: 4, style: .circular))
            .foregroundColor(.ptSecondary)
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
