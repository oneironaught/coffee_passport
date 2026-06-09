import SwiftUI
import GoogleSignInSwift

struct ContentView: View {
    @ObservedObject var viewModel: CoffeeViewModel
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image("Sbux_Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 100)

            Text("Welcome to your Starbucks Coffee Passport!")
                .font(.title3.bold())
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal)

            if authManager.user != nil {
                signedInCard
            } else {
                signedOutCard
            }

            Spacer()

                    if authManager.user != nil {
                        bottomNavigationBar
                    }
                }
        .padding()
        .background(Color.starbucksGreen.ignoresSafeArea())
    }

    // MARK: - Signed In View

    private var signedInCard: some View {
        VStack(spacing: 16) {
            if let url = authManager.profileImageURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                } placeholder: {
                    ProgressView()
                        .tint(.white)
                        .frame(width: 80, height: 80)
                }
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white.opacity(0.9))
            }

            if let name = authManager.displayName {
                Text("Welcome, \(name)!")
                    .font(.title3.bold())
                    .foregroundColor(.white)
            } else {
                Text("Welcome back!")
                    .font(.title3.bold())
                    .foregroundColor(.white)
            }

            Button {
                authManager.signOut()
            } label: {
                Label("Sign Out", systemImage: "arrow.backward.circle.fill")
                    .font(.headline)
                    .foregroundColor(.starbucksGreen)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.14))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.22), lineWidth: 1)
                )
        )
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
    }

    // MARK: - Signed Out View

    private var signedOutCard: some View {
        let buttonWidth: CGFloat = 260
        let buttonHeight: CGFloat = 52

        return VStack(spacing: 18) {
            Text("Sign in to save your Coffee Passport progress")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)

            GoogleSignInButton {
                Task {
                    await authManager.signInWithGoogle()
                }
            }
            .frame(width: buttonWidth, height: buttonHeight)

            HStack {
                Rectangle()
                    .fill(Color.white.opacity(0.35))
                    .frame(height: 1)

                Text("or")
                    .font(.caption.bold())
                    .foregroundColor(.white.opacity(0.8))

                Rectangle()
                    .fill(Color.white.opacity(0.35))
                    .frame(height: 1)
            }
            .frame(width: buttonWidth)

            NavigationLink {
                GuestExploreView()
            } label: {
                HStack {
                    Image(systemName: "person.crop.circle.badge.questionmark")

                    Text("Continue as Guest")
                        .fontWeight(.semibold)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                }
                .foregroundColor(.starbucksGreen)
                .padding(.horizontal)
                .frame(width: buttonWidth, height: buttonHeight)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)

            Text("Guest mode lets you explore coffee education without signing in. Sign in later to save profile-based progress.")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.75))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.14))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.22), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }

    // MARK: - Bottom Navigation

    private var bottomNavigationBar: some View {
        HStack(spacing: 15) {
            NavigationLink(destination: CoffeeListView(viewModel: viewModel)) {
                bottomNavItem(icon: "list.bullet", title: "Coffees")
            }
            .frame(maxWidth: .infinity)

            NavigationLink(destination: CoffeeStatsView(viewModel: viewModel)) {
                bottomNavItem(icon: "chart.bar", title: "Stats")
            }
            .frame(maxWidth: .infinity)

            NavigationLink(destination: CoffeeGalleryView(viewModel: viewModel)) {
                bottomNavItem(icon: "photo.on.rectangle", title: "Gallery")
            }
            .frame(maxWidth: .infinity)

            NavigationLink(destination: CoffeeBadgeView(viewModel: viewModel)) {
                bottomNavItem(icon: "rosette", title: "Badges")
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .padding([.horizontal, .bottom])
    }

    private func bottomNavItem(icon: String, title: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)

            Text(title)
                .font(.caption)
        }
        .foregroundColor(.white)
    }
}
