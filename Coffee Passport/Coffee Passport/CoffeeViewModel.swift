import SwiftUI

class CoffeeViewModel: ObservableObject {
    @Published var coffees: [Coffee] = [] {
        didSet {
            saveCoffees()
        }
    }

    let saveKey = "SavedCoffees"

    init() {
        loadCoffees()
        if coffees.isEmpty { loadSampleCoffees() }
    }

    func addCoffee(name: String, description: String, category: String, details: String?, imageData: Data?) {
        let newCoffee = Coffee(name: name, description: description, category: category, details: details, imageData: imageData)
        coffees.append(newCoffee)
    }

    func deleteCoffee(at offsets: IndexSet) {
        coffees.remove(atOffsets: offsets)
    }

    func toggleTasted(for coffee: Coffee) {
        if let index = coffees.firstIndex(where: { $0.id == coffee.id }) {
            coffees[index].tasted.toggle()
        }
    }

    func toggleFavorite(for coffee: Coffee) {
        if let index = coffees.firstIndex(where: { $0.id == coffee.id }) {
            coffees[index].isFavorite.toggle()
            saveCoffees()
        }
    }

    func earnedBadges() -> [String] {
        let count = coffees.filter { $0.tasted }.count
        var badges: [String] = []

        if count >= 5 { badges.append("Coffee Explorer") }
        if count >= 10 { badges.append("Caffeine Connoisseur") }
        if count >= 15 { badges.append("Master Taster") }

        return badges
    }

    func getCoffeesByCategory(category: String) -> [Coffee] {
        return coffees.filter { $0.category == category }
    }

    private func saveCoffees() {
        if let encoded = try? JSONEncoder().encode(coffees) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    private func loadCoffees() {
        if let savedData = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Coffee].self, from: savedData) {
            coffees = decoded
        }
    }

    private func loadSampleCoffees() {
        coffees = [
            Coffee(
                name: "Sunsera Blend",
                description: "Smooth and sweet with notes of zesty bright citrus and toasted almond.",
                category: "Blonde Roast",
                details: "Crafted for lovers of smooth, flavorful, easy-drinking coffee.",
                imageData: nil,
                origin: "Brazil & Colombia",
                body: "Medium-Light",
                acidity: "Medium",
                processing: "Washed + Sun Dried",
                foodPairing: "Blueberry Streusel Muffin"
            ),
            Coffee(
                name: "Veranda Blend",
                description: "A mellow, lighter-bodied coffee.",
                category: "Blonde Roast",
                details: "Soft and balanced with delicate nuances of lightly roasted nuts.",
                imageData: nil,
                origin: "Latin America",
                body: "Light",
                acidity: "Mild",
                processing: "Washed",
                foodPairing: "Banana Nut Bread"
            ),
            Coffee(
                name: "Blonde Espresso Roast",
                description: "A soft, beautifully balanced flavor profile that pairs perfectly with milk and nondairy alternatives.",
                category: "Blonde Roast",
                details: "Experience the lighter side of espresso. Made up of select Latin American and East African beans, this blend is delicious served hot or over ice.",
                imageData: nil,
                origin: "Latin America",
                body: "Light",
                acidity: "Mild",
                processing: "Washed",
                foodPairing: "Iced Lemon Loaf, Cinnamon Coffee Cake"
            ),
            Coffee(
                name: "Pike Place Roast",
                description: "Smooth, well-rounded blend.",
                category: "Medium Roast",
                details: "Subtle notes of cocoa and toasted nuts.",
                imageData: nil,
                origin: "Latin America",
                body: "Medium",
                acidity: "Medium",
                processing: "Washed",
                foodPairing: "Chocolate Croissant"
            ),
            Coffee(
                name: "French Roast",
                description: "Intense, smoky, dark roast.",
                category: "Dark Roast",
                details: "Bold and full-bodied with a roasty edge.",
                imageData: nil,
                origin: "Multi-region blend",
                body: "Full",
                acidity: "Low",
                processing: "Varied",
                foodPairing: "Chocolate Chip Cookie"
            )
        ]
    }
}
