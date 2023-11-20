import Foundation
import Combine

class UserViewModel: ObservableObject {
    // Local memory for convenience
    @Published var users: [AppUser] = []
    
    // New user to put updates and additions to
    @Published var newUser = AppUser(id: UUID().uuidString, firstName: "", lastName: "", email: "", phoneNumber: "")
    
    @Published var title: String = ""
    @Published var error: Swift.Error?

    init() {
        loadUsers()
    }

    private func loadUsers() {
        // Getting prior information from database for initialization, updates, and additions
        self.users = DatabaseManager.shared.fetchUsers()
    }

    func saveUser(_ newUser: AppUser, _ oldUser: AppUser) -> BooleanLiteralType {
        if let index = users.firstIndex(where: { $0.id == oldUser.id }) {
            // Editing a user in the list via id
            var updatedUser = newUser
            updatedUser.id = oldUser.id // Replacing the newly generated id with the old one for continuity and avoiding database/local meory bugs
            users[index] = updatedUser
            print("Updating user: \(updatedUser)")
            print(users)
            DatabaseManager.shared.updateUser(updatedUser)
        } else {
            // Adds new user to local memory and database
            var newUserToAdd = newUser
            if (DatabaseManager.shared.userAlreadyExists(user: newUser)) {
                print("User already exists")
                return false
            }
            else {
                newUserToAdd.id = UUID().uuidString // Randomly generating UUID for new user
                users.append(newUserToAdd)
                print("Inserting user: \(newUserToAdd)")
                DatabaseManager.shared.insertUser(user: newUserToAdd)
            }
        }
        return true
    }
    
    func deleteAllUsers() {
            DatabaseManager.shared.deleteAllUsers()
            users.removeAll()
    }



    func deleteUser(_ user: AppUser) {
        users.removeAll { $0.id == user.id }
        DatabaseManager.shared.deleteUser(user)
    }
}

