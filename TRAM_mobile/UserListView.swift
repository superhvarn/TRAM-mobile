import SwiftUI

struct UserListView: View {
    // Properties
    @ObservedObject var viewModel: UserViewModel
    @State private var showingAddUserView = false
    @State private var newUser = AppUser(id: UUID().uuidString, firstName: "", lastName: "", email: "", phoneNumber: "")

    // Body
    var body: some View {
        NavigationView {
            List(viewModel.users, id: \.id) { appUser in
                NavigationLink(destination: UserDetailsView(user: appUser, viewModel: viewModel)) {
                    Text(appUser.fullName)
                        .font(.headline)
                        .foregroundColor(.blue) // Setting color blue to user names
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showingAddUserView = true
                    }) {
                        Label("Add User", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        viewModel.deleteAllUsers()
                    }) {
                        Text("Delete All")
                            .font(.callout)
                            .foregroundColor(.red) // Setting color red to the delete all button
                    }
                }
            }
            .sheet(isPresented: $showingAddUserView) {
                UserEditView(user: $newUser, newUser: $newUser, viewModel: viewModel)
                    .edgesIgnoringSafeArea(.all) // Fitting the NavigationView to the entire window
            }
        }
    }
}

struct UserDetailsView: View {
    // Properties
    let user: AppUser
    let viewModel: UserViewModel

    // Body
    var body: some View {
        UserProfileView(viewModel: viewModel, user: user)
    }
}

