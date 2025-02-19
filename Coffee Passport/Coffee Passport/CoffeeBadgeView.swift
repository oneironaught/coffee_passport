import SwiftUI

struct CoffeeBadgeView: View {
    @ObservedObject var viewModel: CoffeeViewModel
    @State private var showConfetti = false

    struct Badge: Identifiable, Equatable {
        let id = UUID()
        let name: String
        let icon: String
    }

    var badges: [Badge] {
        let count = viewModel.coffees.filter { $0.tasted }.count
        var earned: [Badge] = []
        if count >= 5 { earned.append(Badge(name: "Coffee Explorer", icon: "globe.americas.fill")) }
        if count >= 10 { earned.append(Badge(name: "Caffeine Connoisseur", icon: "bolt.fill")) }
        if count >= 15 { earned.append(Badge(name: "Master Taster", icon: "brain.head.profile")) }
        return earned
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                if badges.isEmpty {
                    Text("No badges earned yet.")
                        .foregroundColor(.gray)
                } else {
                    Text("🎖️ Badges Earned")
                        .font(.title3)
                        .bold()

                    ForEach(badges) { badge in
                        HStack {
                            Image(systemName: badge.icon)
                                .foregroundColor(.yellow)
                                .scaleEffect(1.3)
                            Text(badge.name)
                                .font(.headline)
                        }
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .padding(.horizontal)
            .onChange(of: badges.count) {
                withAnimation {
                    showConfetti = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showConfetti = false
                }
            }

            if showConfetti {
                ConfettiView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: badges)
    }
}

struct ConfettiView: View {
    @State private var randomOffsets: [CGSize] = Array(repeating: .zero, count: 15)

    var body: some View {
        ZStack {
            ForEach(0..<15, id: \ .self) { i in
                Circle()
                    .fill(Color.random)
                    .frame(width: 8, height: 8)
                    .offset(randomOffsets[i])
                    .onAppear {
                        withAnimation(Animation.linear(duration: Double.random(in: 1...2)).repeatForever(autoreverses: false)) {
                            randomOffsets[i] = CGSize(width: Double.random(in: -100...100), height: Double.random(in: 300...600))
                        }
                    }
            }
        }
    }
}

extension Color {
    static var random: Color {
        Color(hue: Double.random(in: 0...1), saturation: 0.8, brightness: 0.9)
    }
}
