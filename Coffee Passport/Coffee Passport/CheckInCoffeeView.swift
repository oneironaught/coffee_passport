import SwiftUI

struct CheckInCoffeeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CoffeeViewModel
    var coffee: Coffee
    
    @State private var tastingNote = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false

    var body: some View {
        Form {
            Section(header: Text("Tasting Notes")) {
                TextEditor(text: $tastingNote)
                    .frame(height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
            }

            Section(header: Text("Photo")) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
                
                Button("Take or Choose Photo") {
                    showImagePicker = true
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
                }
            }

            Button("Save Check-In") {
                if let index = viewModel.coffees.firstIndex(where: { $0.id == coffee.id }) {
                    viewModel.coffees[index].tasted = true
                    viewModel.coffees[index].details = tastingNote
                    if let image = selectedImage {
                        viewModel.coffees[index].imageData = image.jpegData(compressionQuality: 0.8)
                    }
                }
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("Check In: \(coffee.name)")
    }
}
