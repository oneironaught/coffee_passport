import SwiftUI

struct CoffeeStatsView: View {
    @ObservedObject var viewModel: CoffeeViewModel
    @State private var filter: FilterType = .all

    enum FilterType: String, CaseIterable, Identifiable {
        case all = "All", tasted = "Tasted", untasted = "Untasted"
        var id: String { rawValue }
    }

    var filteredCoffees: [Coffee] {
        switch filter {
        case .all: return viewModel.coffees
        case .tasted: return viewModel.coffees.filter { $0.tasted }
        case .untasted: return viewModel.coffees.filter { !$0.tasted }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Coffee Check-In Progress")
                .font(.title)
                .padding(.top)

            ProgressView(value: Float(viewModel.coffees.filter { $0.tasted }.count),
                         total: Float(viewModel.coffees.count))
                .padding(.bottom)

            Text("You've tasted \(viewModel.coffees.filter { $0.tasted }.count) of \(viewModel.coffees.count) coffees.")
                .font(.subheadline)

            let badges = viewModel.earnedBadges()
            if !badges.isEmpty {
                Text("🎖️ Achievements").font(.headline).padding(.top)
                ForEach(badges, id: \ .self) { badge in
                    HStack {
                        Image(systemName: "rosette")
                        Text(badge)
                    }
                }
            }

            Picker("Filter", selection: $filter) {
                ForEach(FilterType.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.vertical)

            List(filteredCoffees) { coffee in
                HStack {
                    VStack(alignment: .leading) {
                        Text(coffee.name)
                        Text(coffee.category).font(.caption).foregroundColor(.gray)
                    }
                    Spacer()
                    if coffee.tasted {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                    }
                }
            }

            let tastedWithImages = viewModel.coffees.filter { $0.tasted && $0.imageData != nil }
            if !tastedWithImages.isEmpty {
                Text("Your Coffee Memories").font(.headline).padding(.top)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(tastedWithImages) { coffee in
                            if let data = coffee.imageData, let image = UIImage(data: data) {
                                VStack {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(10)
                                    Text(coffee.name)
                                        .font(.caption)
                                        .frame(width: 100)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Your Coffee Stats")
    }
}
