import SwiftUI
import UIKit

@main
struct CoffeePassportApp: App {
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.starbucksGreen) // Set background color
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // White title text
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Large title text

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct Coffee: Identifiable, Codable {
    var id = UUID()
    var name: String
    var description: String
    var imageData: Data?
}

class CoffeeViewModel: ObservableObject {
    @Published var coffees: [Coffee] = [] {
        didSet {
            saveCoffees()
        }
    }
    
    let saveKey = "SavedCoffees"
    
    init() {
        loadCoffees()
    }
    
    func addCoffee(name: String, description: String, imageData: Data?) {
        let newCoffee = Coffee(name: name, description: description, imageData: imageData)
        coffees.append(newCoffee)
    }
    
    func deleteCoffee(at offsets: IndexSet) {
        coffees.remove(atOffsets: offsets)
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
}






