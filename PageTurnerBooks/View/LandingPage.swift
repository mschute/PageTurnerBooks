//
//  LandingPage.swift
//  PageTurnerBooks
//
//  Created by Staff on 01/05/2024.
//

import SwiftUI

struct LandingPage: View {
    var body: some View {
        Image("PageTurnerLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(30)
            .padding(30)
        Spacer()
        HStack(spacing: 50){
            Button("Sign In") {
                
            }
            Button("Sign Up") {
                
            }
        }
        Spacer()
    }
}

#Preview {
    LandingPage()
}
