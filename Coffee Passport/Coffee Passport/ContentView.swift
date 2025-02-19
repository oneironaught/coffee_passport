import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: CoffeeViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                Image("Sbux_Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)

                Text("Welcome to your Starbucks Coffee Passport!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()

                Spacer()

                // Bottom Navigation Bar
                HStack(spacing: 15) {
                    NavigationLink(destination: CoffeeListView(viewModel: viewModel)) {
                        VStack {
                            Image(systemName: "list.bullet")
                            Text("Coffees")
                        }
                    }
                    .frame(maxWidth: .infinity)

                    NavigationLink(destination: CoffeeStatsView(viewModel: viewModel)) {
                        VStack {
                            Image(systemName: "chart.bar")
                            Text("Stats")
                        }
                    }
                    .frame(maxWidth: .infinity)

                    NavigationLink(destination: CoffeeGalleryView(viewModel: viewModel)) {
                        VStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("Gallery")
                        }
                    }
                    .frame(maxWidth: .infinity)

                    NavigationLink(destination: CoffeeBadgeView(viewModel: viewModel)) {
                        VStack {
                            Image(systemName: "rosette")
                            Text("Badges")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .padding([.horizontal, .bottom])
                .foregroundColor(.white)
            }
            .padding()
            .background(Color.starbucksGreen.ignoresSafeArea())
        }
    }
}
