// Girish code, needs modifying

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


class AuthViewModel: ObservableObject {

    @Published var userSession: FirebaseAuth.User? // check if fb user is logged in, and show either login page or app launch view
    @Published var currentUser: User? // local user
    @Published var isSignedIn = false // flag for sign-in status for access to other views

    var currentUserId: String {
            userSession?.uid ?? ""  // Use the Firebase User uid
        }

    init(){
            self.userSession = Auth.auth().currentUser
            if userSession != nil {
                       self.isSignedIn = true  // Set true if session exists on init
                   }
            if let userSessionNew = userSession {
                print("1...", userSessionNew)
            } else {
                print("no active userSession")
            }

            Task {
                await fetchUser()
            }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            DispatchQueue.main.async {
                self.userSession = result.user
                self.isSignedIn = true
                print("Sign-in successful, User ID:", result.user.uid)
            }
            await fetchUser()
        } catch {
            print("Sign-in failed:", error)
            DispatchQueue.main.async {
                self.isSignedIn = false
            }
        }
    }

    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        print("create User ..")
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            // Switch to the main thread to update the UI
                                DispatchQueue.main.async {
                                    self.userSession = result.user
                                }
            //self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullName, email: email)

            let encodedUser = try Firestore.Encoder().encode(user)

            try await Firestore.firestore().collection("Users").document(user.id).setData(encodedUser)
            await fetchUser() // need to update
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
//        let test = try await Auth.auth().createUser(withEmail: <#T##String#>, password: <#T##String#>)
//        let myTest = test.user
//        let myLocalTest = User(id: myTest.uid, fullName: fullName, email: <#T##String#>)
    }

    func logOut() {
            do {
                try Auth.auth().signOut()
                DispatchQueue.main.async {
                    self.userSession = nil
                    self.currentUser = nil
                    self.isSignedIn = false
                    print("Logged out successfully.")
                }
            } catch {
                print("Logout failed: \(error.localizedDescription)")
            }
        }

    func deleteAccount(){

    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid, !uid.isEmpty else {
            print("User ID is nil or empty.")
            return
        }
        do {
            let snapshot = try await Firestore.firestore().collection("Users").document(uid).getDocument()
            self.currentUser = try snapshot.data(as: User.self)
            print("DEBUG: Current user fetched:", self.currentUser)
        } catch {
            print("Failed to fetch user:", error)
        }
    }
    
}
