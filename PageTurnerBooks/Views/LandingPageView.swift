//
//  LandingPage.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//


import SwiftUI

struct LandingPageView: View {
    var body: some View {
        ZStack{
            VStack(spacing: 100){
                Image("PageTurnerLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(30)
                    .padding(30)
                
                HStack(spacing: 20){
                    CustomButton(title: "Sign In", action: {print("Sign in button tapped")})
                    CustomButton(title: "Sign Up", action: {print("Sign in button tapped")})
                }
                Spacer()
            }
        }
        .globalBackground()
    }
}

#Preview {
    LandingPageView()
}
