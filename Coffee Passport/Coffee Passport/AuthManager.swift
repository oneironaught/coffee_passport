import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UIKit

final class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @Published var user: User?

    private init() {
        if FirebaseApp.app() != nil {
            self.user = Auth.auth().currentUser
        } else {
            self.user = nil
        }
    }

    var displayName: String? {
        user?.displayName
    }

    var profileImageURL: URL? {
        user?.photoURL
    }

    @MainActor
    func refreshCurrentUser() {
        if FirebaseApp.app() != nil {
            self.user = Auth.auth().currentUser
        }
    }

    @MainActor
    func signInWithGoogle() async {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("No CLIENT_ID found. Check GoogleService-Info.plist and FirebaseApp.configure().")
            return
        }

        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)

        guard let rootViewController = getRootViewController() else {
            print("Could not find root view controller.")
            return
        }

        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

            guard let idToken = result.user.idToken?.tokenString else {
                print("Missing Google ID token.")
                return
            }

            let accessToken = result.user.accessToken.tokenString

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: accessToken
            )

            let authResult = try await Auth.auth().signIn(with: credential)
            self.user = authResult.user

            print("Google sign-in successful: \(authResult.user.email ?? "No email")")
        } catch {
            print("Google sign-in failed: \(error.localizedDescription)")
        }
    }

    @MainActor
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            self.user = nil

            print("Signed out successfully.")
        } catch {
            print("Sign out failed: \(error.localizedDescription)")
        }
    }

    @MainActor
    private func getRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }),
              let rootViewController = window.rootViewController else {
            return nil
        }

        return rootViewController
    }
}
