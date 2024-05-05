//
//  Account.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var authViewModel: AuthViewModel  // Injected AuthViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Account")
                    .font(.largeTitle)
                
                // Logout button
                CustomButton(title: "Log Out", action: {
                    authViewModel.logOut()  // Calls logout from AuthViewModel
                })
            }
        }
        .globalBackground()  // Assuming this is a custom modifier you've defined elsewhere
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
