import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {

    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isSignedIn = false

    var currentUserId: String {
        userSession?.uid ?? ""
    }

    init() {
        self.userSession = Auth.auth().currentUser
        if let userSession = userSession {
            print("Session Init - User ID: \(userSession.uid)")
            self.isSignedIn = true
        } else {
            print("Session Init - No active user session")
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
                print("Sign-in successful - User ID: \(result.user.uid)")
            }
            await fetchUser()
        } catch {
            print("Sign-in failed: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.isSignedIn = false
            }
        }
    }

    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            DispatchQueue.main.async {
                self.userSession = result.user
                print("User creation successful - User ID: \(result.user.uid)")
            }
            let user = User(id: result.user.uid, fullName: fullName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            let db = Firestore.firestore()
            try await db.collection("Users").document(user.id).setData(encodedUser)
            print("Firestore user data set for User ID: \(user.id)")
            await fetchUser()
        } catch {
            print("Failed to create user: \(error.localizedDescription)")
        }
    }

    func logOut() {
        guard let user = Auth.auth().currentUser, !user.uid.isEmpty else {
            print("Logout failed - No user session found")
            return
        }

        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.userSession = nil
                self.currentUser = nil
                self.isSignedIn = false
                print("Logged out successfully")
            }
        } catch {
            print("Logout failed: \(error.localizedDescription)")
        }
    }

    func deleteUser(completion: @escaping (Bool, Error?) -> Void) {
        guard let user = Auth.auth().currentUser, !user.uid.isEmpty else {
            print("Delete user failed - No user logged in or invalid user ID")
            completion(false, nil)
            return
        }

        let db = Firestore.firestore()
        db.collection("Users").document(user.uid).delete { error in
            if let error = error {
                print("Failed to delete user data from Firestore: \(error.localizedDescription)")
                completion(false, error)
                return
            }

            user.delete { error in
                if let error = error {
                    print("Failed to delete user account: \(error.localizedDescription)")
                    completion(false, error)
                } else {
                    DispatchQueue.main.async {
                        self.userSession = nil
                        self.currentUser = nil
                        self.isSignedIn = false
                        print("User account deleted successfully.")
                        completion(true, nil)
                    }
                }
            }
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid, !uid.isEmpty else {
            print("Fetch user failed - User ID is nil or empty")
            return
        }
        do {
            let snapshot = try await Firestore.firestore().collection("Users").document(uid).getDocument()
            self.currentUser = try snapshot.data(as: User.self)
            print("Current user fetched: \(String(describing: self.currentUser))")
        } catch {
            print("Failed to fetch user: \(error.localizedDescription)")
        }
    }
}

