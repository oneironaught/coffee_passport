import SwiftUI

struct CoffeeDetailView: View {
    let coffee: Coffee
    @ObservedObject var viewModel: CoffeeViewModel
    @State private var showCheckInView = false
    @State private var showToast = false
    @GestureState private var dragOffset = CGSize.zero

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text(coffee.name)
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                        Button(action: {
                            viewModel.toggleFavorite(for: coffee)
                        }) {
                            Image(systemName: coffee.isFavorite ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.title2)
                        }
                    }
                    .padding(.top)

                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 6) {
                            Image(systemName: "leaf")
                                .foregroundColor(.green)
                            Text(coffee.category.uppercased())
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Divider()

                        HStack(spacing: 6) {
                            Image(systemName: "cup.and.saucer.fill")
                                .foregroundColor(.brown)
                            Text("Flavor Description")
                                .font(.headline)
                        }

                        Text(coffee.description)
                            .font(.body)

                        if let details = coffee.details, !details.isEmpty {
                            Divider()

                            HStack(spacing: 6) {
                                Image(systemName: "note.text")
                                    .foregroundColor(.blue)
                                Text("Tasting Notes")
                                    .font(.headline)
                            }

                            Text(details)
                                .font(.body)
                        }

                        if let origin = coffee.origin {
                            Divider()
                            Label("Origin: \(origin)", systemImage: "globe")
                        }

                        if let body = coffee.body {
                            Label("Body: \(body)", systemImage: "cup.and.saucer")
                        }

                        if let acidity = coffee.acidity {
                            Label("Acidity: \(acidity)", systemImage: "drop")
                        }

                        if let processing = coffee.processing {
                            Label("Processing: \(processing)", systemImage: "arrow.triangle.branch")
                        }

                        if let pairing = coffee.foodPairing {
                            Label("Food Pairing: \(pairing)", systemImage: "fork.knife")
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)

                    Spacer()

                    Button("Check In This Coffee") {
                        showCheckInView = true
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.starbucksGreen)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .gesture(
                    DragGesture(minimumDistance: 50, coordinateSpace: .local)
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation
                        }
                        .onEnded { value in
                            if value.translation.height < -100 {
                                showCheckInView = true
                            }
                        }
                )
            }

            if showToast {
                VStack {
                    Spacer()
                    Text("☕\u{00a0}Successfully Checked In!")
                        .font(.subheadline)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 40)
                }
                .animation(.easeInOut, value: showToast)
            }
        }
        .navigationTitle(coffee.name)
        .sheet(isPresented: $showCheckInView, onDismiss: {
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showToast = false
            }
        }) {
            ZStack {
                VisualEffectBlur()
                    .ignoresSafeArea()
                CheckInCoffeeView(viewModel: viewModel, coffee: coffee)
                    .padding()
            }
        }
    }
}


// Blur background helper
struct VisualEffectBlur: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
