import SwiftUI

struct CoffeeListView: View {
    let featuredCoffees = [
        "Starbucks Reserve Guatemala",
        "Starbucks Reserve Kenya",
        "Starbucks Reserve Colombia"
    ]
    
    let generalCoffees = [
        "Pike Place Roast",
        "Espresso Roast",
        "Sumatra",
        "House Blend",
        "French Roast",
        "Veranda Blend"
    ]

    var body: some View {
        VStack {
            Text("Starbucks Whole Bean Coffees")
                .font(.largeTitle)
                .bold()
                .padding()

            List {
                Section(header: Text("Featured Coffees").font(.headline)) {
                    ForEach(featuredCoffees, id: \.self) { coffee in
                        Text(coffee)
                    }
                }

                Section(header: Text("General Coffees").font(.headline)) {
                    ForEach(generalCoffees, id: \.self) { coffee in
                        Text(coffee)
                    }
                }
            }
        }
        .navigationTitle("Explore Coffees")
    }
}
