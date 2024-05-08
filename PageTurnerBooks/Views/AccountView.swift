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
    @State private var confirmPassword: String = ""
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
                    }
                    
                    // TODO: Bug Fix button alignment to leading
                    .padding()
                    
                }
                //TODO: Change to Turner book color
                .accentColor(.blue)
                
                DisclosureGroup("Password", isExpanded: $showPasswordFields){
                    VStack(alignment: .leading, spacing: 15){
                        //TODO: Need to add user validation to confirm current password
                        SecureField("Current Password", text: $currentPassword)
                        SecureField("New Password", text: $newPassword)
                        SecureField("Confirm New Password", text: $confirmPassword)
                        
                        Button("Update Password") {
                            if newPassword == confirmPassword {
                                Task {
                                    do {
                                        try await authViewModel.updatePassword(currentPassword: currentPassword, newPassword: newPassword)
                                    } catch {
                                        print("Failed to update password: \(error.localizedDescription)")
                                    }
                                }
                            } else {
                                print("The new passwords do not match.")
                            }
                        }
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
                    
                    // Delete account needs to be in a separate VStack from logout, Xcode fails delete account function otherwise
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
