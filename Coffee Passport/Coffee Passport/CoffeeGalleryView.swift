import SwiftUI

struct CoffeeGalleryView: View {
    @ObservedObject var viewModel: CoffeeViewModel

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.coffees.filter { $0.tasted }) { coffee in
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
                                Image(systemName: "cup.and.saucer")
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
        .navigationTitle("Coffee Gallery")
        .background(Color.starbucksGreen.ignoresSafeArea())
    }
}

