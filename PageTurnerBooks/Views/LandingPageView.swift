//
//  LandingPage.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//


import SwiftUI

struct LandingPageView: View {
    var body: some View {
        NavigationStack {  // Only one NavigationStack should be the root
            VStack(spacing: 100) {
                //TODO: Add new logo
                Image("PageTurnerLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(30)
                    .padding(30)
                
                HStack(spacing: 20) {
                    // NavigationLink for Sign In
                    NavigationLink(destination: SignInView()) {
                        Text("Sign In")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    // NavigationLink for Sign Up
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                        
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                Spacer()
            }
        }
    }
}


struct LandingPageView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView()
    }
}
