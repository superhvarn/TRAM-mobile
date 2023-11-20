import SwiftUI

struct UserEditView: View {
    @Binding var user: AppUser
    @Binding var newUser: AppUser
    @State private var tempUser: AppUser
    @State private var showingAlert = false
    @State private var sucessAlert = false
    var viewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode


    init(user: Binding<AppUser>, newUser: Binding<AppUser>, viewModel: UserViewModel) {
        _user = user
        _newUser = newUser
        _tempUser = State(initialValue: user.wrappedValue)
        self.viewModel = viewModel
    }

    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                Form {
                    Section(header: Text("Personal Information")) {
                        TextField("First Name", text: $tempUser.firstName)
                            .font(.headline)
                        TextField("Last Name", text: $tempUser.lastName)
                            .font(.headline)
                        TextField("Email", text: $tempUser.email)
                            .font(.headline)
                        TextField("Phone", text: $tempUser.phoneNumber)
                            .font(.headline)
                    }
                    Section {
                        Button("Save Changes") {
                            if (viewModel.saveUser(tempUser, user)) == false {
                                showingAlert = true
                            }
                            else {
                                sucessAlert = true
                            }
                
                        }
                        .alert("User already exists", isPresented: $showingAlert) {
                                    Button("OK", role: .cancel) { presentationMode.wrappedValue.dismiss()}
                                }
                        .alert("User sucessfully created", isPresented: $sucessAlert) {
                                    Button("OK", role: .cancel) { presentationMode.wrappedValue.dismiss()}
                                }
                        .buttonStyle(GradientButtonStyle()) // Applying Gradient Button instead of default
    
                    }
                }
                .padding()
                .navigationTitle("Edit Profile")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                Spacer() // Fits Form to entire window
            }
        }
        .frame(width: 800, height: 200) // Setting width and height of window
    }
}

// Defining GradientButton for saving changes
struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct UserEditView_Previews: PreviewProvider {
    static var previews: some View {
        let userViewModel = UserViewModel()
        let previewUser = AppUser(id: UUID().uuidString, firstName: "John", lastName: "Doe", email: "john.doe@example.com", phoneNumber: "123-456-7890")

        return UserEditView(user: .constant(previewUser), newUser: .constant(previewUser), viewModel: userViewModel)
    }
}

