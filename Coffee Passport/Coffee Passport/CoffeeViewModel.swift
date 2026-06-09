import SwiftUI

class CoffeeViewModel: ObservableObject {
    @Published var coffees: [Coffee] = [] {
        didSet {
            saveCoffees()
        }
    }

    private let saveKey = "SavedCoffees"
    private let sampleVersionKey = "SampleCoffeeVersion"

    // Increase this number any time you add, remove, rename, or reorder sample coffees.
    private let currentSampleVersion = 5

    init() {
        loadCoffees()

        let savedVersion = UserDefaults.standard.integer(forKey: sampleVersionKey)

        if savedVersion < currentSampleVersion || coffees.isEmpty {
            syncSampleCoffees()
            UserDefaults.standard.set(currentSampleVersion, forKey: sampleVersionKey)
        }
    }

    // MARK: - Public Functions

    func addCoffee(
        name: String,
        description: String,
        category: String,
        details: String?,
        imageData: Data?,
        origin: String? = nil,
        body: String? = nil,
        acidity: String? = nil,
        processing: String? = nil,
        foodPairing: String? = nil
    ) {
        let newCoffee = Coffee(
            name: name,
            description: description,
            category: category,
            details: details,
            imageData: imageData,
            origin: origin,
            body: body,
            acidity: acidity,
            processing: processing,
            foodPairing: foodPairing
        )

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

    // MARK: - Save / Load

    private func saveCoffees() {
        if let encoded = try? JSONEncoder().encode(coffees) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    private func loadCoffees() {
        if let savedData = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Coffee].self, from: savedData) {
            coffees = decoded
        } else {
            coffees = []
        }
    }

    // MARK: - Sample Coffee Sync

    private func syncSampleCoffees() {
        let samples = sampleCoffees()
        let sampleNames = Set(samples.map { normalizedCoffeeName($0.name) })

        // Old default coffees you no longer want in your main curated list.
        let retiredSampleNames = Set([
            "Breakfast Blend",
            "House Blend",
            "French Roast"
        ].map { normalizedCoffeeName($0) })

        var syncedSamples: [Coffee] = []

        for sample in samples {
            if let existingCoffee = coffees.first(where: {
                normalizedCoffeeName($0.name) == normalizedCoffeeName(sample.name)
            }) {
                var updatedCoffee = existingCoffee

                // Update the curated coffee info while keeping user progress.
                updatedCoffee.name = sample.name
                updatedCoffee.description = sample.description
                updatedCoffee.category = sample.category
                updatedCoffee.details = sample.details
                updatedCoffee.origin = sample.origin
                updatedCoffee.body = sample.body
                updatedCoffee.acidity = sample.acidity
                updatedCoffee.processing = sample.processing
                updatedCoffee.foodPairing = sample.foodPairing

                syncedSamples.append(updatedCoffee)
            } else {
                syncedSamples.append(sample)
            }
        }

        // Keep user-added coffees.
        // Retired sample coffees are removed unless the user already checked/favorited/added an image to them.
        let userAddedCoffees = coffees.filter { coffee in
            let normalizedName = normalizedCoffeeName(coffee.name)
            let isCurrentSample = sampleNames.contains(normalizedName)
            let isRetiredSample = retiredSampleNames.contains(normalizedName)

            let hasUserProgress = coffee.tasted || coffee.isFavorite || coffee.imageData != nil

            if isCurrentSample {
                return false
            }

            if isRetiredSample {
                return hasUserProgress
            }

            return true
        }

        coffees = syncedSamples + userAddedCoffees
        saveCoffees()
    }

    private func normalizedCoffeeName(_ name: String) -> String {
        name
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Sample Coffee List

    private func sampleCoffees() -> [Coffee] {
        return [
            // MARK: - Blonde Roast

            Coffee(
                name: "Sunsera Blend",
                description: "Smooth and bright with notes of zesty citrus and toasted almond.",
                category: "Blonde Roast",
                details: "A smooth, easy-drinking Blonde Roast crafted for a bright and flavorful cup. Its sun-dried coffee character gives it a soft sweetness that works well hot or iced.",
                imageData: nil,
                origin: "Brazil & Colombia",
                body: "Medium-Light",
                acidity: "Medium",
                processing: "Washed + Sun-Dried",
                foodPairing: "Blueberry Streusel Muffin, Chocolate Croissant, Toasted Almond Biscotti"
            ),

            Coffee(
                name: "Veranda Blend",
                description: "Mellow and soft with notes of toasted malt and milk chocolate.",
                category: "Blonde Roast",
                details: "A lighter-bodied Latin American coffee with a soft, approachable profile and gentle roasty sweetness.",
                imageData: nil,
                origin: "Latin America",
                body: "Light",
                acidity: "Medium",
                processing: "Washed",
                foodPairing: "Banana Nut Bread, Madeleines, Milk Chocolate"
            ),

            Coffee(
                name: "Blonde Espresso Roast",
                description: "Smooth and subtly sweet with a balanced flavor profile.",
                category: "Blonde Roast",
                details: "A lighter espresso roast made with select Latin American and East African coffees. It pairs beautifully with milk and nondairy alternatives and works well hot or iced.",
                imageData: nil,
                origin: "Latin America & East Africa",
                body: "Light",
                acidity: "Medium",
                processing: "Washed",
                foodPairing: "Iced Lemon Loaf, Vanilla Scone, Cinnamon Coffee Cake"
            ),

            Coffee(
                name: "Green Apron Blend",
                description: "Lively and refreshing with notes of honeybell orange and graham cracker.",
                category: "Blonde Roast",
                details: "Created in honor of Starbucks partners who wear the iconic green apron. This bright blend brings together African and Latin American coffees for a refreshing, citrus-forward cup.",
                imageData: nil,
                origin: "Africa & Latin America",
                body: "Medium",
                acidity: "Medium",
                processing: "Washed",
                foodPairing: "Orange Slices, Graham Crackers, Iced Lemon Loaf"
            ),

            // MARK: - Medium Roast

            Coffee(
                name: "Siren's Blend",
                description: "Bright and lively with notes of juicy citrus and chocolate.",
                category: "Medium Roast",
                details: "Inspired by trailblazing women in coffee, this blend combines African coffees for citrus and floral brightness with Latin American coffees for balance and chocolate depth.",
                imageData: nil,
                origin: "Latin America & Africa",
                body: "Medium",
                acidity: "Medium-High",
                processing: "Washed",
                foodPairing: "Iced Lemon Loaf, Candied Citrus, Milk Chocolate"
            ),

            Coffee(
                name: "Iced Coffee Blend",
                description: "Approachable and refreshing with notes of malted milk chocolate and brown sugar.",
                category: "Medium Roast",
                details: "Crafted to be brewed hot and served over ice, this Latin American blend delivers a smooth and refreshing iced-coffee experience.",
                imageData: nil,
                origin: "Latin America",
                body: "Medium-Light",
                acidity: "Medium",
                processing: "Washed",
                foodPairing: "Double Chocolate Brownie, Brown Sugar Oatmeal, Iced Lemon Loaf"
            ),

            Coffee(
                name: "Cold Brew Blend",
                description: "Smooth and rich with notes of cocoa and citrus.",
                category: "Medium Roast",
                details: "Designed for slow, cold-water brewing. This blend develops a smooth body, subtle sweetness, and lower acidity.",
                imageData: nil,
                origin: "Latin America & Africa",
                body: "Full",
                acidity: "Low",
                processing: "Washed",
                foodPairing: "Chocolate Croissant, Cinnamon Coffee Cake, Orange Slices"
            ),

            Coffee(
                name: "Pike Place Roast",
                description: "Smooth and balanced with subtle notes of cocoa and toasted nuts.",
                category: "Medium Roast",
                details: "A smooth, well-rounded Latin American blend created for an everyday cup with a consistent finish.",
                imageData: nil,
                origin: "Latin America",
                body: "Medium",
                acidity: "Medium",
                processing: "Washed",
                foodPairing: "Chocolate Croissant, Cinnamon Coffee Cake, Peanut Butter"
            ),

            Coffee(
                name: "Guatemala Antigua",
                description: "Elegant and complex with notes of cocoa and soft spice.",
                category: "Medium Roast",
                details: "A refined single-origin coffee from Guatemala’s Antigua Valley, known for volcanic soil, depth, and balanced complexity.",
                imageData: nil,
                origin: "Guatemala",
                body: "Medium",
                acidity: "High",
                processing: "Washed",
                foodPairing: "Chocolate Croissant, Apple Pastry, Caramel, Nuts"
            ),

            Coffee(
                name: "Organic Yukon Blend",
                description: "Big, bold, and balanced with hearty herbal notes and subtle acidity.",
                category: "Medium Roast",
                details: "A multi-region blend inspired by coffees that could stand up to long, cold days. Latin American coffees bring balance while Asia/Pacific coffees add earthy depth.",
                imageData: nil,
                origin: "Latin America & Asia/Pacific",
                body: "Full",
                acidity: "Medium",
                processing: "Washed + Semi-Washed",
                foodPairing: "Classic Oatmeal, Cinnamon Coffee Cake, Morning Bun"
            ),

            // MARK: - Dark Roast

            Coffee(
                name: "Sumatra",
                description: "Earthy and herbal with rustic spice and a syrupy body.",
                category: "Dark Roast",
                details: "A bold Asia/Pacific coffee known for full body, low acidity, and distinctive earthy complexity.",
                imageData: nil,
                origin: "Asia/Pacific",
                body: "Full",
                acidity: "Low",
                processing: "Semi-Washed",
                foodPairing: "Cheese Danish, Maple Bar, Oatmeal, Cinnamon"
            ),

            Coffee(
                name: "Komodo Dragon",
                description: "Bold and spicy with rich herbal and cedary notes.",
                category: "Dark Roast",
                details: "A powerful Asia/Pacific dark roast with earthy depth, herbal complexity, and a strong lingering finish.",
                imageData: nil,
                origin: "Asia/Pacific",
                body: "Full",
                acidity: "Low",
                processing: "Washed + Semi-Washed",
                foodPairing: "Brie Cheese, Maple Bar, Buttery Pastries, Cinnamon"
            ),

            Coffee(
                name: "Cafe Verona",
                description: "Roasty and sweet with notes of dark cocoa and caramelized sugar.",
                category: "Dark Roast",
                details: "A full-bodied multi-region blend inspired by romance and chocolate. Caffè Verona brings together Latin American and Asia/Pacific coffees for depth and sweetness.",
                imageData: nil,
                origin: "Multi-region blend",
                body: "Full",
                acidity: "Low",
                processing: "Washed + Semi-Washed",
                foodPairing: "Chocolate Croissant, Chocolate Chip Cookie, Dark Chocolate"
            ),

            Coffee(
                name: "Espresso Roast",
                description: "Rich and caramelly with notes of molasses and caramelized sugar.",
                category: "Dark Roast",
                details: "A classic dark roast and the heart of Starbucks espresso beverages. Bold, sweet, and balanced for espresso drinks.",
                imageData: nil,
                origin: "Multi-region blend",
                body: "Full",
                acidity: "Medium",
                processing: "Washed",
                foodPairing: "Double Chocolate Brownie, Chocolate Caramels, Caramel Desserts"
            ),

            Coffee(
                name: "Italian Roast",
                description: "Roasty and sweet with notes of dark cocoa and toasted marshmallow.",
                category: "Dark Roast",
                details: "A darker roast inspired by Southern Italian roasting traditions. Slightly darker than Espresso Roast with deep sweetness and intensity.",
                imageData: nil,
                origin: "Multi-region blend",
                body: "Medium",
                acidity: "Low",
                processing: "Washed",
                foodPairing: "Chocolate, Caramelized Sugar, Spice Cake"
            )
        ]
    }

    // MARK: - Development Helper

    func resetAllData() {
        UserDefaults.standard.removeObject(forKey: saveKey)
        UserDefaults.standard.removeObject(forKey: sampleVersionKey)
        coffees = []
        syncSampleCoffees()
        UserDefaults.standard.set(currentSampleVersion, forKey: sampleVersionKey)
    }
}
