import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: CoffeeViewModel

    var favoriteCoffees: [Coffee] {
        viewModel.coffees.filter { $0.isFavorite }
    }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            if favoriteCoffees.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "star")
                        .font(.system(size: 50))
                        .foregroundColor(.yellow)
                    Text("No favorites yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding()
            } else {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(favoriteCoffees) { coffee in
                        NavigationLink(destination: CoffeeDetailView(coffee: coffee, viewModel: viewModel)) {
                            VStack {
                                if let data = coffee.imageData, let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 150)
                                        .clipped()
                                        .cornerRadius(12)
                                } else {
                                    Image(systemName: "cup.and.saucer.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.gray)
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(12)
                                }
                                Text(coffee.name)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(4)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Favorite Coffees")
        .background(Color.starbucksGreen.ignoresSafeArea())
    }
}
