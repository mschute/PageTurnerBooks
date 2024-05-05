// Girish code, needs modifying

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


class AuthViewModel: ObservableObject {

    @Published var userSession: FirebaseAuth.User? // check if fb user is logged in? and show either login page or app launch view
    @Published var currentUser: User? // local user

    init(){
        self.userSession = Auth.auth().currentUser
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

        print("Sign in ..")
        do {
            let result =  try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to sign in  user with error \(error.localizedDescription)")
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

    func logOut(){
        do {
            try Auth.auth().signOut() // signs out user on backend
            self.userSession = nil // wipes out user session and presents login screen
            self.currentUser = nil //wipes out current user data model
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }

    }

    func deleteAccount(){

    }
    
    func fetchUser() async {
        print("fetch active")
        guard let uid = Auth.auth().currentUser?.uid else { return }
       print("uid.....\(uid)")
        do{
            let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument()
            //let user = snapshot?.data(as: User.self)
            self.currentUser = try snapshot?.data(as: User.self)
            print("DEBUG: Current user is \(String(describing: self.currentUser))")
        } catch {
            print("DEBUG: did not get user \(error.localizedDescription)")
        }

    }
    
}
