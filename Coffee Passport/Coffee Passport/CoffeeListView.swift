import SwiftUI

struct CoffeeListView: View {
    @ObservedObject var viewModel: CoffeeViewModel

    @State private var selectedRoast: String = "All"
    @State private var selectedAcidity: String = "All"
    @State private var selectedBody: String = "All"
    @State private var selectedOrigin: String = "All"

    private let roastCategories = ["All", "Blonde Roast", "Medium Roast", "Dark Roast"]

    var filteredCoffees: [Coffee] {
        viewModel.coffees.filter { coffee in
            let matchesRoast = selectedRoast == "All" || coffee.category == selectedRoast
            let matchesAcidity = selectedAcidity == "All" || coffee.acidity == selectedAcidity
            let matchesBody = selectedBody == "All" || coffee.body == selectedBody
            let matchesOrigin = selectedOrigin == "All" || coffee.origin == selectedOrigin

            return matchesRoast && matchesAcidity && matchesBody && matchesOrigin
        }
    }

    var uniqueAcidity: [String] {
        ["All"] + Set(viewModel.coffees.compactMap { $0.acidity }).sorted()
    }

    var uniqueBody: [String] {
        ["All"] + Set(viewModel.coffees.compactMap { $0.body }).sorted()
    }

    var uniqueOrigin: [String] {
        ["All"] + Set(viewModel.coffees.compactMap { $0.origin }).sorted()
    }

    var tastedCount: Int {
        viewModel.coffees.filter { $0.tasted }.count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                heroSection
                roastPicker
                filterSection
                coffeeListSection
            }
            .padding()
        }
        .navigationTitle("Coffee Passport")
        .background(Color.starbucksGreen.ignoresSafeArea())
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 14) {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 38))
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Check In Your Coffees")
                        .font(.title2.bold())
                        .foregroundColor(.white)

                    Text("\(tastedCount) of \(viewModel.coffees.count) coffees tasted")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))
                }

                Spacer()
            }

            NavigationLink {
                ExploreView()
            } label: {
                HStack {
                    Image(systemName: "sparkles")
                    Text("Explore")
                        .fontWeight(.semibold)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                }
                .padding()
                .background(Color.white)
                .foregroundColor(Color.starbucksGreen)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    Color.white.opacity(0.18),
                    Color.white.opacity(0.07)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var roastPicker: some View {
        Picker("Roast", selection: $selectedRoast) {
            ForEach(roastCategories, id: \.self) { category in
                Text(category).tag(category)
            }
        }
        .pickerStyle(.segmented)
    }

    private var filterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Filter Your Coffees")
                .font(.headline)
                .foregroundColor(.white)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 12
            ) {
                filterPicker(title: "Acidity", selection: $selectedAcidity, options: uniqueAcidity)
                filterPicker(title: "Body", selection: $selectedBody, options: uniqueBody)
                filterPicker(title: "Origin", selection: $selectedOrigin, options: uniqueOrigin)
            }

            Button {
                selectedRoast = "All"
                selectedAcidity = "All"
                selectedBody = "All"
                selectedOrigin = "All"
            } label: {
                Label("Reset Filters", systemImage: "arrow.counterclockwise")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.black.opacity(0.18))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func filterPicker(
        title: String,
        selection: Binding<String>,
        options: [String]
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.85))

            Picker(title, selection: selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }

    private var coffeeListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Coffees")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()

                Text("\(filteredCoffees.count)")
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.2))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }

            if filteredCoffees.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                        .foregroundColor(.white.opacity(0.8))

                    Text("No coffees match these filters.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(filteredCoffees) { coffee in
                        NavigationLink {
                            CoffeeDetailView(coffee: coffee, viewModel: viewModel)
                        } label: {
                            CoffeePassportRow(coffee: coffee)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

struct CoffeePassportRow: View {
    let coffee: Coffee

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(roastColor.opacity(0.18))
                    .frame(width: 58, height: 58)

                Image(systemName: coffee.tasted ? "checkmark.seal.fill" : "cup.and.saucer.fill")
                    .font(.title2)
                    .foregroundColor(roastColor)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(coffee.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(coffee.category)
                    .font(.caption)
                    .foregroundColor(.secondary)

                if let origin = coffee.origin {
                    Text(origin)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            VStack(spacing: 8) {
                if coffee.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }

                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
    }

    private var roastColor: Color {
        switch coffee.category {
        case "Blonde Roast":
            return .yellow
        case "Medium Roast":
            return .brown
        case "Dark Roast":
            return .black
        default:
            return .gray
        }
    }
}
