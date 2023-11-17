import Foundation

struct UserProfile: Identifiable {
    var id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String

    init(firstName: String, lastName: String, email: String, phoneNumber: String) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
    }
}

