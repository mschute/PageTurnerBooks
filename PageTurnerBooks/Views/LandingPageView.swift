//
//  LandingPage.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//


import SwiftUI

struct LandingPageView: View {
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
    LandingPageView()
}
