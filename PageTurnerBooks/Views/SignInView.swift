// Girish code, needs modifying

import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
            VStack {
                Image("fb")
                    .resizable()
                    .scaledToFit()
                    .offset(y: -10)
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)

                VStack(spacing: 25) {
                    // Email input field using standard SwiftUI TextField
                    TextField("Email Address", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()

                    // Password input field using standard SwiftUI SecureField
                    SecureField("Enter your password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    // Link to navigate to the SignUpView
                    NavigationLink(destination: SignUpView()) {
                        Text("Don't have an account? Sign Up")
                            .foregroundColor(.blue)
                    }

                    // Login button
                    Button(action: {
                        print("Login button tapped")
                        Task {
                            try await authViewModel.signIn(withEmail: email, password: password)
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
                .padding(.horizontal)
                .padding(.top, 10)
            }
            .navigationBarBackButtonHidden(true)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

