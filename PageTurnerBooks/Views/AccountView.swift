//
//  Account.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var authViewModel: AuthViewModel  // Injected AuthViewModel
    @State private var showEmailFields = false
    @State private var showPasswordFields = false
    @State private var newEmail: String = ""
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""
    //TODO: Unsure about the look of the inputfields in the Account Information. Especially with the "Old email" mixed in
    
    var body: some View {
        Form{
            Section(header: Text("Account Information").font(.headline)){
                DisclosureGroup("Email", isExpanded: $showEmailFields){
                    VStack(alignment: .leading){
                        //TODO: Need to link to current email
                        Text("Old email: get old email")
                            .padding(.bottom, 10)
                        InputField(text: $newEmail, title: "New Email", placeholder: "Enter your new email")
                            .keyboardType(.default)
                        SmallPrimaryButton(title: "Save", action: {
                            //TODO: Need to add action to save email
                            print("email updated")
                        })
                        
                    }
                    // TODO: Bug Fix button alignment to leading
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                }
                //TODO: Change to Turner book color
                .accentColor(.blue)
                
                DisclosureGroup("Password", isExpanded: $showPasswordFields){
                    VStack(alignment: .leading, spacing: 15){
                        //TODO: Need to add user validation to confirm current password
                        InputField(text: $currentPassword, title: "Current Password", placeholder: "Enter current password", isSecureField: true)
                            .keyboardType(.default)
                        InputField(text: $newPassword, title: "New Password", placeholder: "Enter new password", isSecureField: true)
                            .keyboardType(.default)
                        //TODO: Need to add user validation to confirm new password and confirm new password match
                        InputField(text: $currentPassword, title: "Confirm New Password", placeholder: "Confirm new password", isSecureField: true)
                            .keyboardType(.default)
                            
                        //TODO: Need to add functionality to update password
                        SmallPrimaryButton(title: "Update Password", action: {
                            print("Updated password")
                        })
                    }
                    // TODO: Bug Fix button alignment to leading
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                //TODO: Change to Turner book color
                .accentColor(.blue)
                
                Section{
                    VStack{
                        //TODO: Make Sign Out button Red?
                        //TODO: Should this just be another option in the form rather than a button? It may look cleaner, its a bit chunky right now
                        // Logout button
                        //TODO: Redo the button
                        PrimaryButton(title: "Sign Out", action: {
                            authViewModel.logOut()
                        })
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        Divider()
                        
                        Button("Delete Account", action: authViewModel.deleteAccount)
                            .padding(5)
                        //TODO: Change to Turner book color
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }
}

// Preview with environment object (Mock AuthViewModel if needed)
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()  // Create an instance for preview purposes
        AccountView()
            .environmentObject(authViewModel)  // Provide the AuthViewModel to the environment
    }
}
