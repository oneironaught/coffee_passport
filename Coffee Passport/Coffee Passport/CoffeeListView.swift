import SwiftUI

struct CoffeeListView: View {
    @ObservedObject var viewModel: CoffeeViewModel
    @State private var selectedAcidity: String = "All"
    @State private var selectedBody: String = "All"
    @State private var selectedOrigin: String = "All"

    var filteredCoffees: [Coffee] {
        viewModel.coffees.filter { coffee in
            (selectedAcidity == "All" || coffee.acidity == selectedAcidity) &&
            (selectedBody == "All" || coffee.body == selectedBody) &&
            (selectedOrigin == "All" || coffee.origin == selectedOrigin)
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

    var body: some View {
        VStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Filter Your Coffees")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top)

                HStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        Text("Acidity")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Picker("Acidity", selection: $selectedAcidity) {
                            ForEach(uniqueAcidity, id: \ .self) { acidity in
                                Text(acidity)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                    }

                    VStack(alignment: .leading) {
                        Text("Body")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Picker("Body", selection: $selectedBody) {
                            ForEach(uniqueBody, id: \ .self) { body in
                                Text(body)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                    }

                    VStack(alignment: .leading) {
                        Text("Origin")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Picker("Origin", selection: $selectedOrigin) {
                            ForEach(uniqueOrigin, id: \ .self) { origin in
                                Text(origin)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                }

                Button("Reset Filters") {
                    selectedAcidity = "All"
                    selectedBody = "All"
                    selectedOrigin = "All"
                }
                .font(.subheadline)
                .padding(.top, 4)
                .foregroundColor(.white)
            }
            .padding([.horizontal, .top])

            List {
                ForEach(filteredCoffees) { coffee in
                    NavigationLink(destination: CoffeeDetailView(coffee: coffee, viewModel: viewModel)) {
                        VStack(alignment: .leading) {
                            Text(coffee.name)
                                .font(.body)
                            if let details = coffee.details, !details.isEmpty {
                                Text("📝 Notes Added")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Check In Your Coffees")
        .background(Color.starbucksGreen.ignoresSafeArea())
    }
}
