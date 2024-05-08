// Girish code, needs modifying

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
            VStack() {
                Text("Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 60)
                    .shadow(color: .pTPrimary, radius: 0.5)
                
                VStack(spacing: 20) {
                    TextField("Email Address", text: $email)
                        .pTTextFieldStyle()
                        .padding(.horizontal)
                        .autocapitalization(.none)
                        .focused($fieldIsFocused)
                    //TODO: Need to make sure this keyboard works correctly
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                        .pTTextFieldStyle()
                        .padding(.horizontal)
                        .focused($fieldIsFocused)
                    //TODO: Need to make sure this keyboard works correctly
                        .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    
                    //TODO: Bug the error messsage is not showing up when I enter in an incorrect value
                    VStack(spacing: 40){
                        PrimaryButton(title: "Sign In", action: {
                            fieldIsFocused = false
                            Task {
                                do {
                                    try await authViewModel.signIn(withEmail: email, password: password)
                                    DispatchQueue.main.async {
                                        self.shouldShowAccountView = authViewModel.isSignedIn
                                    }
                                } catch {
                                    self.errorMessage = "Failed to sign in. Please check your email and password combination."
                                    self.showingError = true
                                }
                            }
                        })
                        .padding(.top, 30)
//                        .buttonStyle(email.isEmpty || password.isEmpty ? AnyButtonStyle(DisabledButtonStyle()) : AnyButtonStyle(PrimaryButtonStyle()))
                        .disabled(email.isEmpty || password.isEmpty)
                        .alert("Error", isPresented: $showingError, actions: {
                            Button("Close", role: .cancel) { }
                        }, message: {
                            Text(errorMessage)
                        })
                        
                        HStack{
                            Text("No Account?")
                            NavigationLink(destination: SignUpView()) {
                                Text("Sign Up")
                                    .foregroundColor(.pTSecondary)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding()
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)

        }
        .fullScreenCover(isPresented: $shouldShowAccountView) {
            AccountView()
        }
    }
}
    
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

