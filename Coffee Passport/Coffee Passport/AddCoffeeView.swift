import SwiftUI

struct AddCoffeeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CoffeeViewModel
    @State private var name = ""
    @State private var description = ""
    @State private var category = "Blonde Roast"
    @State private var details = ""
    @State private var selectedUIImage: UIImage?

    let categories = ["Blonde Roast", "Medium Roast", "Dark Roast"]

    var body: some View {
        Form {
            TextField("Coffee Name", text: $name)
            Picker("Category", selection: $category) {
                ForEach(categories, id: \.self) { Text($0) }
            }
            .pickerStyle(SegmentedPickerStyle())
            TextEditor(text: $details).frame(height: 100)

            Button("Save") {
                viewModel.addCoffee(name: name, description: description, category: category, details: details, imageData: nil)
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
