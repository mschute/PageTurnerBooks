//
//  LandingPage.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//


import SwiftUI

struct LandingPageView: View {
    var body: some View {
            NavigationStack {
                VStack(spacing: 20){
                    RotateLogo()
                        .padding()
                    HStack(spacing: 30) {
                        NavigationLink(destination: SignInView()) {
                            Text("Sign In")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                            
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    }
                    Spacer()
                }
                .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.3)]), startPoint: .top, endPoint: .bottom),
                            ignoresSafeAreaEdges: .all)
                .navigationBarHidden(true)
        }
    }
}


struct LandingPageView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView()
    }
}
