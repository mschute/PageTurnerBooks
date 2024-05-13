//
//  LandingPage.swift

import SwiftUI

struct LandingPageView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("backgroundImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.2)
                    .padding(.bottom, -50)
                
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
