//
//  PageTurnerBooksApp.swift

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

