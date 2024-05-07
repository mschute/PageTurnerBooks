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
    @State private var showingDeleteConfirmation = false
    //TODO: Unsure about the look of the inputfields in the Account Information. Especially with the "Old email" mixed in
    
    var body: some View {
        Form{
            Text("Account Information")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .center)
            Section(){
                DisclosureGroup("Email", isExpanded: $showEmailFields){
                    VStack(alignment: .leading){
                        if let email = authViewModel.currentUser?.email {
                            Text("Current Email: \(email)")
                                .padding(.bottom, 10)
                        }
                        InputField(text: $newEmail, title: "New Email", placeholder: "Enter your new email")
                            .keyboardType(.default)
                        SmallPrimaryButton(title: "Save", action: {
                            //TODO: Need to add action to save email
                            print("email updated")
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // TODO: Bug Fix button alignment to leading
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
                            //TODO: Add confirmation that the password was saved?
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
                    }
                    
                    
                    VStack{
                        Button("Delete Account", action: {
                            print("Delete button pressed. Attempting to delete user...")
                            authViewModel.deleteUser()
                        })
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
    }
}
