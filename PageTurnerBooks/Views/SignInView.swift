// Girish code, needs modifying

import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var shouldShowAccountView = false
    
    var body: some View {
        VStack {
            VStack(spacing: 25) {
                TextField("Email Address", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                
                SecureField("Enter your password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                NavigationLink(destination: SignUpView()) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    print("Login button tapped")
                    Task {
                        try await authViewModel.signIn(withEmail: email, password: password)
                        DispatchQueue.main.async {
                            self.shouldShowAccountView = authViewModel.isSignedIn
                        }
                    }
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.top, 20)
            }
            .fullScreenCover(isPresented: $shouldShowAccountView) {
                AccountView()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

