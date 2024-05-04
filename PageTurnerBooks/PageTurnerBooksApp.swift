//
//  PageTurnerBooksApp.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//

import SwiftUI

struct RootView: View {
    //@StateObject var authViewModel = AuthViewModel()
    
    var body: some View {
//        if authViewModel.isAuthenticated {
            NavBar()
//        } else {
//            LandingPageView()
//                .environmentObject(authViewModel)
//        }
        
    }
}
@main
struct PageTurnerBooksApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

