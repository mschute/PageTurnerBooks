//
//  PageTurnerBooksApp.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//

import SwiftUI
import Firebase

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
    @StateObject var authViewModel = AuthViewModel()
    init(){
        FirebaseApp.configure()
        print("Firebase configured.")
    }
    var body: some Scene {
        WindowGroup {
            LandingPageView().environmentObject(authViewModel)
        }
    }
}

