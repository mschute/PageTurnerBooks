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
            ZStack {
                VStack(spacing: 100) {
                    Image("PageTurnerLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(30)
                        .padding(30)
                    
                    HStack(spacing: 20) {
                        // NavigationLink for Sign In
                        NavigationLink(destination: SignInView()) {
                            Text("Sign In")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }

                        // NavigationLink for Sign Up
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green) // Just to differentiate
                                .cornerRadius(8)
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

