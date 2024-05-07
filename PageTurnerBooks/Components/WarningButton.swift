//
//  WarningButton.swift
//  PageTurnerBooks
//
//  Created by Staff on 07/05/2024.
//

import SwiftUI

struct WarningButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action){
            Text(title)
        }
        .font(.system(size: 18, weight: .bold, design: .default))
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.8), Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .foregroundColor(Color.white)
        .font(.system(size: 20, weight: .bold, design: .default))
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        .frame(minWidth: 100, idealWidth: .infinity, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
    }
}

struct WarningButton_Previews: PreviewProvider {
    static var previews: some View {
        WarningButton(title: "Test Button", action: {
            print("preview button tapped")})
        
    }
}
