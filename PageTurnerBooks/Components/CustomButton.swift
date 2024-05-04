//
//  Button.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//


import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void
    
    // Need to edit so it has min size but then have the button size adjusted based on words
    var body: some View {
        Button(action: action){
            Text(title)
        }
        .frame(width: 140, height: 50)
        .background(Color.blue.gradient)
        .foregroundColor(Color.white)
        .font(.system(size: 20, weight: .bold, design: .default))
        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
    }
}

#Preview {
    CustomButton(title: "test title", action: {
        print("preview button tapped")})
}
