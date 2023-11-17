import SwiftUI

struct UserProfileView: View {
    @ObservedObject var viewModel: UserViewModel
    @State var user: AppUser
    @State private var tempUser: AppUser
    @State private var isEditing = false
    @Environment(\.presentationMode) var presentationMode

    init(viewModel: UserViewModel, user: AppUser) {
        self.viewModel = viewModel
        self._user = State(initialValue: user)
        self._tempUser = State(initialValue: user)
    }

    var body: some View {
        Form {
            Section(header: Text("Personal Information").font(.headline)) {
                if isEditing {
                    TextField("First Name", text: $tempUser.firstName)
                    TextField("Last Name", text: $tempUser.lastName)
                    TextField("Email", text: $tempUser.email)

                    TextField("Phone Number", text: $tempUser.phoneNumber)

                } else {
                    Text(user.firstName)
                    Text(user.lastName)
                    Text(user.email)
                    Text(user.phoneNumber)
                }
            }

            Section {
                Button(action: {
                    isEditing.toggle()
                }) {
                    Text(isEditing ? "Cancel" : "Edit Profile")
                        .foregroundColor(.white)
                        .padding()
                        .background(isEditing ? Color.red : Color.blue)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                
                if isEditing {
                    Button(action: {
                        viewModel.saveUser(tempUser, user)
                        user = tempUser
                        isEditing.toggle()
                    }) {
                        Text("Save Changes")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }

            Section {
                Button(action: {
                    viewModel.deleteUser(user)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Delete User")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

