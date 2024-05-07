// Girish code, needs modifying

import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var shouldShowAccountView = false
//    @State private var showingError = false
//    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 50) {
            Text("Sign In ")
                .font(.largeTitle)
            Spacer()
            VStack(spacing: 30) {
                TextField("Email Address", text: $email)
                    .pTTextFieldStyle()
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Enter your password", text: $password)
                    .pTTextFieldStyle()
                    
                
                NavigationLink(destination: SignUpView()) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                }
                
                //TODO: Need to add error message if incorrect
                PrimaryButton(title: "Sign In", action: {
                    Task {
                        try await authViewModel.signIn(withEmail: email, password: password)
                        DispatchQueue.main.async {
                            self.shouldShowAccountView = authViewModel.isSignedIn
                        }
                    }
                })
                Spacer()
                              //TODO: Test this error message later when I can sign in
//                    Task {
//                        do{
//                            try await authViewModel.signIn(withEmail: email, password: password)
//                            DispatchQueue.main.async {
//                                self.shouldShowAccountView = authViewModel.isSignedIn
//                            }
//                        } catch {
//                            self.errorMessage = "Failed to sign in. Please check your email and password combination."
//                            self.showingError = true
//                        }
//                    }
//                })
//                .alert("Error", isPresented: $showingError, actions: {
//                    Button("Close", role: .cancel) { }
//                }, message: {
//                    Text(errorMessage)
//                })
                

            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $shouldShowAccountView) {
                AccountView()
            }
            .navigationBarBackButtonHidden(true)
        }
        .padding(20)
    }
    
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

