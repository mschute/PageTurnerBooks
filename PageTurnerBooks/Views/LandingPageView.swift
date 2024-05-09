//
//  LandingPage.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//


import SwiftUI

struct LandingPageView: View {
    var body: some View {
        //TODO: Sliver of white space at the bottom
        //TODO: Adjust for landscape
        NavigationStack {
            ZStack{
                Image("backgroundImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.2)
                
                Spacer(minLength: 40)
                VStack{
                    
                    RotateLogo()
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity)
                    
                    Spacer(minLength: 100)
                    
                    VStack(spacing: 20){
                        HStack(spacing: 20) {
                            NavigationLink(destination: SignInView()) {
                                Text("Sign In")
                            }
                            .buttonStyle(SecondaryButtonStyle())
                            
                            NavigationLink(destination: SignUpView()) {
                                Text("Sign Up")
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .navigationBarHidden(true)
                }
            }
        }
    }
}


struct LandingPageView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView()
    }
}
