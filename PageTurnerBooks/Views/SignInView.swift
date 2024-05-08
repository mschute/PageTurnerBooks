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
        //TODO: Style choice stripe? or visit sign up page for other view
        NavigationStack{
            VStack(spacing: 20) {
                ScrollView{
                    Text("Sign In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pTPrimary)
                        .padding(.top, 40)
                        .padding(.bottom, 50)
                    
                    VStack(spacing: 20) {
                        TextField("Email Address", text: $email)
                            .pTTextFieldStyle()
                            .padding(.horizontal)
                            .autocapitalization(.none)
                            .focused($fieldIsFocused)
                            .keyboardType(.emailAddress)
                        
                        SecureField("Password", text: $password)
                            .pTTextFieldStyle()
                            .padding(.horizontal)
                            .focused($fieldIsFocused)
                            .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                        
                        VStack(spacing: 30){
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
                            .background(email.isEmpty || password.isEmpty ? Color.gray : Color.pTPrimary)
                            .foregroundColor(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                            .frame(minWidth: 100, minHeight: 50, maxHeight: 50, alignment: .center)
                            .padding(.top, 20)
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

