//
//  ContentView.swift

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel  // This provides access to the AuthViewModel instance.
    
    var body: some View {
        Group {
            if authViewModel.isSignedIn {
                // Access 'currentUserId' directly without needing a binding.
                NavBar()
                    .environmentObject(BooksListViewModel(userId: authViewModel.currentUserId))
            } else {
                LandingPageView()
            }
        }
    }
}
