// Girish code, needs modifying

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
            VStack {
                Text("Register")
                    .font(.largeTitle)
                Spacer()
                VStack(spacing: 25) {
                    // Email input field
                    InputField(text: $email, title: "Email Address", placeholder: "name@example.com", isSecureField: false)
                        .autocapitalization(.none)

                    // Full name input field
                    InputField(text: $fullName, title: "Full Name", placeholder: "John Doe", isSecureField: false)

                    // Password input field
                    InputField(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                        .autocapitalization(.none)

                    // Confirm Password input field
                    InputField(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your password", isSecureField: true)
                        .autocapitalization(.none)
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // Register button can be added here.
                NavigationLink(destination: SignInView()) {
                                    Text("Already have an account? Sign In")
                        
                                        .foregroundColor(.blue)
                                }
                .padding(.top, 30)
                

                // Button to perform registration (printing a message to the console for now)
                                Button(action: {
                                    print("Register button tapped")
                                    Task {
                                        try await authViewModel.createUser(withEmail:email, password:password,fullName: fullName)

                                    }
                                }) {
                                    Text("Register")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                }
                                .padding(.top, 30)
                .navigationBarBackButtonHidden(true)
                Spacer()
            }
            .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
