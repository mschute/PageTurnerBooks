// Girish code, needs modifying

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    @FocusState private var fieldIsFocused: Bool

    @EnvironmentObject var authViewModel: AuthViewModel
    
    //TODO: The title gets pushed up out of screen when the keyboard appears. I think because the input fields get pushed up. Maybe put the fields in a scroll view to rectify that?
    //TODO: After registration, directed to sign-in page
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
                
                Button("Register", action: {
                    fieldIsFocused = false
                    Task {
                        Task {
                            try await authViewModel.createUser(withEmail:email, password:password,fullName: fullName)
                        }
                    }
                })
                .font(.system(size: 18, weight: .bold, design: .default))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(email.isEmpty || fullName.isEmpty || password.isEmpty || confirmPassword.isEmpty ? Color.gray : Color.pTSecondary)
                .foregroundColor(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                .frame(minWidth: 100, minHeight: 50, maxHeight: 50, alignment: .center)
                .padding(.top, 20)
                .disabled(email.isEmpty || fullName.isEmpty || password.isEmpty || confirmPassword.isEmpty)
                .navigationBarBackButtonHidden(true)
                .alert("Error", isPresented: $showingError, actions: {
                    Button("Close", role: .cancel) { }
                }, message: {
                    Text(errorMessage)
                })
                
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
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
