import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct CoffeePassportApp: App {
    @StateObject private var viewModel: CoffeeViewModel
    @StateObject private var authManager: AuthManager

    init() {
        FirebaseApp.configure()

        if let clientID = FirebaseApp.app()?.options.clientID {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
            print("Google Sign-In configured successfully.")
        } else {
            print("Missing Firebase client ID. Check GoogleService-Info.plist target membership.")
        }

        _viewModel = StateObject(wrappedValue: CoffeeViewModel())
        _authManager = StateObject(wrappedValue: AuthManager.shared)

        AuthManager.shared.refreshCurrentUser()

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.starbucksGreen)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(viewModel: viewModel)
                    .environmentObject(authManager)
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
            }
        }
    }
}
