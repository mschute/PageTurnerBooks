//
// SignInView.swift

import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var shouldShowAccountView = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @FocusState private var fieldIsFocused: Bool
    
    var body: some View {

        NavigationStack{
            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.pTPrimary)
                .padding(.top, 50)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ScrollView {
                    VStack(spacing: 25) {
                        InputField(text: $email, title: "Email Address", placeholder: "name@example.com", isSecureField: false)
                            .keyboardType(.emailAddress)
                            .focused($fieldIsFocused)
                            .autocapitalization(.none)
  
                        InputField(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .focused($fieldIsFocused)
                        
                        VStack(spacing: 30) {
                            
                            Button("Sign In", action: {
                                fieldIsFocused = false
                                Task {
                                    do {
                                        try await authViewModel.signIn(withEmail: email, password: password)
                                        DispatchQueue.main.async {
                                            self.shouldShowAccountView = authViewModel.isSignedIn
                                        }
                                    } catch {
                                        errorMessage = "Failed to sign in. Please check your email and password combination."
                                        showingError = true
                                    }
                                }
                            })
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(email.isEmpty || password.isEmpty ? Color.gray : Color.pTSecondary)
                            .foregroundColor(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                            .frame(minWidth: 100, minHeight: 50, maxHeight: 50, alignment: .center)
                            .padding(.top, 40)
                            .disabled(email.isEmpty || password.isEmpty)
                            .alert("Error", isPresented: $showingError, actions: {
                                Button("Close", role: .cancel) { }
                            }, message: {
                                Text(errorMessage)
                            })
                            
                            HStack {
                                
                                Text("No Account?")
                                NavigationLink(destination: SignUpView()) {
                                    Text("Sign Up")
                                        .foregroundColor(.pTSecondary)
                                        .fontWeight(.bold)
                                }
                            }
                            .padding(30)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                }
                .navigationBarBackButtonHidden(true)
                .onTapGesture{
                    fieldIsFocused = false
                }
            }
            .fullScreenCover(isPresented: $shouldShowAccountView) {
                AccountView()
            }
        }
    }
}
    
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

