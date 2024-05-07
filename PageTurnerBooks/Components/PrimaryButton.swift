//
//  Button.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//


import SwiftUI

struct PrimaryButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action){
            Text(title)
        }
        .font(.system(size: 18, weight: .bold, design: .default))
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .foregroundColor(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        .frame(minWidth: 100, idealWidth: .infinity, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
    }
}

#Preview {
    PrimaryButton(title: "Test button", action: {
        print("preview button tapped")})
}
