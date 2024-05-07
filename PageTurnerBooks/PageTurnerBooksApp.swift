//
//  PageTurnerBooksApp.swift
//  PageTurnerBooks
//
//  Created by Brad on 03/05/2024.
//

import SwiftUI
import Firebase

@main
struct PageTurnerBooksApp: App {
    @StateObject var authViewModel = AuthViewModel()

    init() {
        FirebaseApp.configure()
        print("Firebase configured.")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}

