//
//  ContentView.swift
//  PageTurnerBooks
//
//  Created by Brad on 05/05/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            if authViewModel.isSignedIn {
                AccountView()
            } else {
                LandingPageView()
            }
        }
    }
}
