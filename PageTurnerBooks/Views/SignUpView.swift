//
// SignUpView.swift

import SwiftUI

//TODO: The title gets pushed up out of screen when the keyboard appears. I think because the input fields get pushed up. Maybe put the fields in a scroll view to rectify that?

struct SignUpView: View {
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var navigateToSignIn = false
    @State private var showingSuccess = false

    @EnvironmentObject var authViewModel: AuthViewModel
    @FocusState private var fieldIsFocused: Bool

    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.pTPrimary)
            
            VStack(spacing: 25) {
                InputField(text: $email, title: "Email Address", placeholder: "name@example.com", isSecureField: false)
                    .keyboardType(.emailAddress)
                    .focused($fieldIsFocused)
                    .autocapitalization(.none)
                
                InputField(text: $fullName, title: "Full Name", placeholder: "John Doe", isSecureField: false)
                    .keyboardType(.default)
                    .focused($fieldIsFocused)
                
                InputField(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                    .autocapitalization(.none)
                    .keyboardType(.default)
                    .focused($fieldIsFocused)
                
                InputField(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your password", isSecureField: true)
                    .autocapitalization(.none)
                    .keyboardType(.default)
                    .focused($fieldIsFocused)
            }
            .padding(40)
            .padding(.top, 20)

            VStack(spacing: 30) {
                Button("Register", action: registerUser)
                .font(.system(size: 18, weight: .bold, design: .default))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(email.isEmpty || fullName.isEmpty || password.isEmpty || confirmPassword.isEmpty ? Color.gray : Color.pTSecondary)
                .foregroundColor(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                .frame(minWidth: 100, minHeight: 50, maxHeight: 50, alignment: .center)
                .padding(.top, 20)
                .disabled(email.isEmpty || fullName.isEmpty || password.isEmpty || confirmPassword.isEmpty)
                
                NavigationLink(destination: SignInView(), isActive: $navigateToSignIn) { EmptyView() }

                HStack {
                    Text("Already have an account?")
                    NavigationLink(destination: SignInView()) {
                        Text("Sign In")
                            .foregroundColor(.pTSecondary)
                            .fontWeight(.bold)
                    }
                }
                .padding(.top, 30)
                Spacer()
            }
        }
        .alert("Registration Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .alert("Registration Successful", isPresented: $showingSuccess) {
            Button("OK") {
                navigateToSignIn = true
            }
        } message: {
            Text("Your account has been created successfully. Please sign in.")
        }
    }

    private func registerUser() {
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            showingError = true
            return
        }

        Task {
            do {
                try await authViewModel.createUser(withEmail: email, password: password, fullName: fullName) { success, message in
                    if success {
                        showingSuccess = true
                    } else {
                        errorMessage = message
                        showingError = true
                    }
                }
            } catch {
                errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
                showingError = true
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView().environmentObject(AuthViewModel.mock)
    }
}
