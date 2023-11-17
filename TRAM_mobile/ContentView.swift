import SwiftUI

struct ContentView: View {
    // Initializing the model to pass into the view
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        NavigationSplitView {
            UserListView(viewModel: viewModel)
        } detail: {
            Text("Select a user")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

