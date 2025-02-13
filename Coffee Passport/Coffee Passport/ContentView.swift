import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CoffeeViewModel()
    @State private var showingAddCoffee = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer(minLength: 10) // Pushes the image to the top
                Image("Sbux_Logo")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding()
                
                Text("""
                Welcome to your Starbucks Coffee Passport!
                Keep track of all the Starbucks whole bean coffees you've tried, add descriptions, and capture photos of your experiences.
                """)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.white)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.white)
                
                NavigationLink(destination: CoffeeListView()) {
                    Text("Explore Coffees")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(Color.starbucksGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal, 20)
                }
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .foregroundColor(.white)
  
                
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
                                        .foregroundColor(.white)
                                    Text(coffee.description)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                }
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteCoffee)
                }
                .listStyle(PlainListStyle())
            }
            .foregroundColor(.white)
            .background(Color.starbucksGreen.ignoresSafeArea())
            .background(Color("StarbucksGreen"))
            .navigationTitle("Coffee Passport")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddCoffee = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
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
    @State private var selectedImageData: Data? = nil
    @State private var selectedUIImage: UIImage? = nil
    @State private var showCamera = false

    var body: some View {
        NavigationView {
            Form {
                TextField("Coffee Name", text: $name)
                ZStack(alignment: .topLeading) {
                    if description.isEmpty {
                        Text("Description")
                            .foregroundColor(Color.gray.opacity(0.5)) 
                            .padding(.top, 8)
                            .padding(.leading, 5)
                    }
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .padding(4)
                }
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
