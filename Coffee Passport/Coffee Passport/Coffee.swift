import SwiftUI
import Foundation

struct Coffee: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var description: String
    var category: String
    var details: String?
    var imageData: Data?
    var tasted: Bool = false
    var isFavorite: Bool = false
    var origin: String?
    var body: String?
    var acidity: String?
    var processing: String?
    var foodPairing: String?
}
