//
//  Button.swift
//  PageTurnerBooks
//
//  Created by Staff on 01/05/2024.
//

import SwiftUI

struct Button: View {
    var body: some View {
        Button(){
            Text()
        }
        .frame(width: 200, height: 50)
        .background(Color.blue.gradient)
        .foregroundColor(Color.white)

        .font(.system(size: 20, weight: .bold, design: .default))
        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
    }
}

#Preview {
    Button()
}
