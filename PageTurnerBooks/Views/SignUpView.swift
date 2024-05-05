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
                Image("fb")
                    .resizable()
                    .scaledToFit()
                    .offset(y: -10)
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)

                VStack(spacing: 25) {
                    // Email input field
                    inputField(text: $email, title: "Email Address", placeholder: "name@example.com", isSecureField: false)
                        .autocapitalization(.none)

                    // Full name input field
                    inputField(text: $fullName, title: "Full Name", placeholder: "John Doe", isSecureField: false)

                    // Password input field
                    inputField(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                        .autocapitalization(.none)

                    // Confirm Password input field
                    inputField(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your password", isSecureField: true)
                        .autocapitalization(.none)
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // Register button can be added here.
                NavigationLink(destination: SignInView()) {
                                    Text("Already have an account? Sign In")
                                        .foregroundColor(.blue)
                                }

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
                                .padding(.top, 20)
                .navigationBarBackButtonHidden(true)
            }
    }

    // Shouldn't have a function in a view, need to change
    func inputField(text: Binding<String>, title: String, placeholder: String, isSecureField: Bool) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)

            // Depending on whether it's a secure field or not, use TextField or SecureField.
            if isSecureField {
                SecureField(placeholder, text: text)
                    .font(.system(size: 14))
            } else {
                TextField(placeholder, text: text)
                    .font(.system(size: 14))
            }

            Divider()

        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

