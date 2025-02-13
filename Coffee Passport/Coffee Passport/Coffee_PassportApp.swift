import SwiftUI
import PhotosUI
import UIKit

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

struct ContentView: View {
    @StateObject private var viewModel = CoffeeViewModel()
    @State private var showingAddCoffee = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.coffees) { coffee in
                    NavigationLink(destination: CoffeeDetailView(coffee: coffee)) {
                        HStack {
                            if let imageData = coffee.imageData, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            VStack(alignment: .leading) {
                                Text(coffee.name)
                                    .font(.headline)
                                Text(coffee.description)
                                    .font(.subheadline)
                                    .lineLimit(2)
                            }
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteCoffee)
            }
            .navigationTitle("Coffee Passport")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddCoffee = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddCoffee) {
                AddCoffeeView(viewModel: viewModel)
            }
        }
    }
}

struct AddCoffeeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CoffeeViewModel
    @State private var name = ""
    @State private var description = ""
    @State private var showCamera = false
    @State private var selectedImageData: Data? = nil
    @State private var selectedUIImage: UIImage? = nil
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Coffee Name", text: $name)
                TextEditor(text: $description)
                    .frame(height: 100)
                Button("Take Photo") {
                    showCamera.toggle()
                }
                .sheet(isPresented: $showCamera) {
                    ImagePicker(sourceType: .camera, selectedImage: $selectedUIImage)
                }
                
                if let uiImage = selectedUIImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
            }
            .navigationTitle("Add New Coffee")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let uiImage = selectedUIImage, let data = uiImage.jpegData(compressionQuality: 0.8) {
                            viewModel.addCoffee(name: name, description: description, imageData: data)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty || description.isEmpty)
                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }
    }
}

struct CoffeeDetailView: View {
    var coffee: Coffee
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let imageData = coffee.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                }
                Text(coffee.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                Text(coffee.description)
                    .font(.body)
                    .padding(.top, 5)
            }
            .padding()
        }
        .navigationTitle(coffee.name)
    }
}

@main
struct CoffeePassportApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

