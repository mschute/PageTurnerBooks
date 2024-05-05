// Girish code, may need modifying

import Foundation
struct User: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
}
extension User {
    static var MOCK_USER = User(id: UUID().uuidString, fullName: "Test User", email: "testuser@test.com")
}

