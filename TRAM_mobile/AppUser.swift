import Foundation

struct AppUser: Identifiable, Equatable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String

    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

