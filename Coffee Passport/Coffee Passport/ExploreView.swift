import SwiftUI

struct ExploreView: View {
    private let topics = CoffeeExploreLibrary.topics

    private let columns = [
        GridItem(.adaptive(minimum: 155), spacing: 14)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(topics) { topic in
                        NavigationLink {
                            ExploreDetailView(topic: topic)
                        } label: {
                            ExploreTopicCard(topic: topic)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Explore")
        .background(Color.starbucksGreen.ignoresSafeArea())
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Coffee Education")
                .font(.largeTitle.bold())
                .foregroundColor(.white)

            Text("Learn about coffee origins, sourcing, roasting, brewing, and tasting.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ExploreTopicCard: View {
    let topic: CoffeeExploreTopic

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: topic.icon)
                .font(.title2)
                .foregroundColor(Color.starbucksGreen)

            Text(topic.title)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)

            Text(topic.subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(3)

            Spacer()

            HStack {
                Text("Open")
                    .font(.caption.bold())
                    .foregroundColor(Color.starbucksGreen)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(Color.starbucksGreen)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 165, alignment: .topLeading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}

struct ExploreDetailView: View {
    let topic: CoffeeExploreTopic

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                detailHeader

                ForEach(topic.sections) { section in
                    ExploreInfoCard(section: section)
                }
            }
            .padding()
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.starbucksGreen.ignoresSafeArea())
    }

    private var detailHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: topic.icon)
                .font(.largeTitle)
                .foregroundColor(.white)

            Text(topic.title)
                .font(.largeTitle.bold())
                .foregroundColor(.white)

            Text(topic.subtitle)
                .font(.body)
                .foregroundColor(.white.opacity(0.88))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

struct ExploreInfoCard: View {
    let section: CoffeeExploreSection

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.heading)
                .font(.title3.bold())
                .foregroundColor(.primary)

            if let body = section.body {
                Text(body)
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            if !section.bullets.isEmpty {
                VStack(alignment: .leading, spacing: 9) {
                    ForEach(section.bullets, id: \.self) { bullet in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(Color.starbucksGreen)
                                .padding(.top, 3)

                            Text(bullet)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }

            if let callout = section.callout {
                Text(callout)
                    .font(.callout)
                    .foregroundColor(Color.starbucksGreen)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.starbucksGreen.opacity(0.10))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Models

struct CoffeeExploreTopic: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let sections: [CoffeeExploreSection]
}

struct CoffeeExploreSection: Identifiable {
    let id = UUID()
    let heading: String
    let body: String?
    let bullets: [String]
    let callout: String?

    init(
        heading: String,
        body: String? = nil,
        bullets: [String] = [],
        callout: String? = nil
    ) {
        self.heading = heading
        self.body = body
        self.bullets = bullets
        self.callout = callout
    }
}

// MARK: - Explore Content Library

enum CoffeeExploreLibrary {
    static let topics: [CoffeeExploreTopic] = [
        CoffeeExploreTopic(
            id: "growing-regions",
            title: "Growing Regions",
            subtitle: "Explore the major coffee-growing regions and how origin affects flavor.",
            icon: "globe.americas.fill",
            sections: [
                CoffeeExploreSection(
                    heading: "Why Growing Regions Matter",
                    body: "Coffee flavor is shaped by climate, elevation, soil, rainfall, processing, and farming traditions. Two coffees can taste completely different depending on where and how they were grown."
                ),
                CoffeeExploreSection(
                    heading: "Latin America",
                    bullets: [
                        "Often known for balanced acidity, cocoa notes, nuts, citrus, and clean finishes.",
                        "Common origins include Colombia, Guatemala, Costa Rica, Brazil, and Mexico.",
                        "Many Latin American coffees are washed processed, creating clarity and brightness."
                    ],
                    callout: "Great examples in your passport: Veranda Blend, Pike Place Roast, Guatemala Antigua, and Espresso Roast."
                ),
                CoffeeExploreSection(
                    heading: "Africa",
                    bullets: [
                        "Often known for floral aromas, citrus, berry notes, and lively acidity.",
                        "Common origins include Ethiopia, Kenya, Rwanda, Tanzania, and Uganda.",
                        "African coffees can bring brightness and complexity to blends."
                    ]
                ),
                CoffeeExploreSection(
                    heading: "Asia/Pacific",
                    bullets: [
                        "Often known for full body, earthy depth, herbal notes, spice, and low acidity.",
                        "Common origins include Sumatra, Indonesia, Papua New Guinea, and East Timor.",
                        "These coffees are often used to add weight, richness, and lingering finish."
                    ],
                    callout: "Great examples in your passport: Sumatra, Komodo Dragon, Organic Yukon Blend, and Caffè Verona."
                )
            ]
        ),

        CoffeeExploreTopic(
            id: "ethical-sourcing",
            title: "Committed to Ethical Sourcing",
            subtitle: "Learn how coffee sourcing can support farmers, workers, communities, and the environment.",
            icon: "heart.fill",
            sections: [
                CoffeeExploreSection(
                    heading: "What Ethical Sourcing Means",
                    body: "Ethical sourcing is about buying coffee in a way that supports quality, transparency, responsible farming, fair treatment of workers, and long-term sustainability."
                ),
                CoffeeExploreSection(
                    heading: "C.A.F.E. Practices",
                    bullets: [
                        "C.A.F.E. stands for Coffee and Farmer Equity.",
                        "The program evaluates farms and supply chains across economic, social, and environmental standards.",
                        "The goal is to encourage transparent, responsible, and sustainable coffee production."
                    ]
                ),
                CoffeeExploreSection(
                    heading: "Why It Matters",
                    bullets: [
                        "Coffee is grown by people and communities around the world.",
                        "Responsible sourcing helps protect farmer livelihoods and coffee quality.",
                        "Long-term support can help coffee farms adapt to climate, disease, and economic pressure."
                    ],
                    callout: "A cup of coffee represents a chain of people: growers, pickers, processors, buyers, roasters, baristas, and customers."
                )
            ]
        ),

        CoffeeExploreTopic(
            id: "farmer-support-centers",
            title: "Farmer Support Centers",
            subtitle: "See how agronomy support helps coffee farmers improve quality and resilience.",
            icon: "building.columns.fill",
            sections: [
                CoffeeExploreSection(
                    heading: "What They Are",
                    body: "Farmer Support Centers are places where coffee farmers can receive agronomy support, training, and resources designed to improve coffee quality, productivity, and sustainability."
                ),
                CoffeeExploreSection(
                    heading: "What Farmers Can Learn",
                    bullets: [
                        "Soil health and plant nutrition.",
                        "Coffee tree disease prevention.",
                        "Responsible water use.",
                        "Harvesting and processing methods.",
                        "Climate-resilient farming practices."
                    ]
                ),
                CoffeeExploreSection(
                    heading: "Why They Matter",
                    bullets: [
                        "Better farming practices can improve cup quality.",
                        "Healthy farms can be more productive over time.",
                        "Support centers can help preserve the future supply of high-quality coffee."
                    ],
                    callout: "Farmer support connects the beginning of the coffee journey to the final cup."
                )
            ]
        ),

        CoffeeExploreTopic(
            id: "sustainability",
            title: "Sustainability",
            subtitle: "Understand the connection between coffee, climate, farms, water, and communities.",
            icon: "leaf.fill",
            sections: [
                CoffeeExploreSection(
                    heading: "Coffee and the Environment",
                    body: "Coffee is an agricultural product, which means it depends on healthy soil, reliable water, stable climate, and resilient farming communities."
                ),
                CoffeeExploreSection(
                    heading: "Key Sustainability Focus Areas",
                    bullets: [
                        "Protecting soil health through responsible farming.",
                        "Using water carefully during coffee processing.",
                        "Supporting shade, biodiversity, and healthy ecosystems.",
                        "Helping farmers prepare for climate change.",
                        "Reducing waste throughout the coffee journey."
                    ]
                ),
                CoffeeExploreSection(
                    heading: "Customer Connection",
                    body: "When you learn where your coffee comes from, you can better appreciate the people and natural resources behind every cup.",
                    callout: "Sustainability is not only about the environment. It is also about people, quality, and the long-term future of coffee."
                )
            ]
        ),

        CoffeeExploreTopic(
            id: "processing",
            title: "Processing",
            subtitle: "Learn how coffee cherries become green coffee beans ready for roasting.",
            icon: "arrow.triangle.2.circlepath",
            sections: [
                CoffeeExploreSection(
                    heading: "What Processing Means",
                    body: "Processing is the method used to remove the coffee seed from the coffee cherry. This happens before the coffee is dried, milled, shipped, and roasted."
                ),
                CoffeeExploreSection(
                    heading: "Washed Processing",
                    bullets: [
                        "The fruit is removed before drying.",
                        "Often creates a clean, bright, and consistent cup.",
                        "Common in many Latin American and African coffees."
                    ]
                ),
                CoffeeExploreSection(
                    heading: "Natural Processing",
                    bullets: [
                        "The coffee cherry dries with the fruit still around the seed.",
                        "Can create fruitier, heavier, wine-like flavors.",
                        "Requires careful drying and sorting."
                    ]
                ),
                CoffeeExploreSection(
                    heading: "Semi-Washed Processing",
                    bullets: [
                        "Common in parts of Asia/Pacific.",
                        "Can create earthy, herbal, full-bodied coffees.",
                        "Often associated with lower acidity and deep complexity."
                    ],
                    callout: "Processing has a major impact on flavor before roasting ever begins."
                )
            ]
        ),

        CoffeeExploreTopic(
            id: "single-origin-blends",
            title: "Single-Origin & Blends",
            subtitle: "Compare coffees from one place with coffees crafted from multiple origins.",
            icon: "map.fill",
            sections: [
                CoffeeExploreSection(
                    heading: "Single-Origin Coffee",
                    body: "Single-origin coffee comes from one country, region, cooperative, or farm. It highlights the character of a specific place."
                ),
                CoffeeExploreSection(
                    heading: "Why Choose Single-Origin?",
                    bullets: [
                        "To experience a specific region clearly.",
                        "To compare how origin changes flavor.",
                        "To learn more about growing conditions and processing."
                    ],
                    callout: "Example: Guatemala Antigua highlights the character of Guatemala’s Antigua Valley."
                ),
                CoffeeExploreSection(
                    heading: "Coffee Blends",
                    body: "A blend combines coffees from different origins to create balance, consistency, or a specific flavor profile."
                ),
                CoffeeExploreSection(
                    heading: "Why Create Blends?",
                    bullets: [
                        "To balance acidity, body, aroma, and finish.",
                        "To create a consistent flavor experience.",
                        "To combine the strengths of different growing regions."
                    ],
                    callout: "Example: Caffè Verona uses different origins to create depth, sweetness, and richness."
                )
            ]
        ),

        CoffeeExploreTopic(
            id: "roasting",
            title: "Roasting",
            subtitle: "See how roast level transforms green coffee into aromatic roasted beans.",
            icon: "flame.fill",
            sections: [
                CoffeeExploreSection(
                    heading: "What Roasting Does",
                    body: "Roasting uses heat to transform green coffee beans into the aromatic brown beans used for brewing. Roast time and temperature shape sweetness, acidity, body, aroma, and flavor."
                ),
                CoffeeExploreSection(
                    heading: "Blonde Roast",
                    bullets: [
                        "Lighter roast profile.",
                        "Often softer, brighter, and lighter-bodied.",
                        "Can highlight citrus, floral, malt, and toasted notes."
                    ]
                ),
                CoffeeExploreSection(
                    heading: "Medium Roast",
                    bullets: [
                        "Balanced roast profile.",
                        "Often smooth, rounded, and approachable.",
                        "Can highlight cocoa, nuts, citrus, and mild sweetness."
                    ]
                ),
                CoffeeExploreSection(
                    heading: "Dark Roast",
                    bullets: [
                        "Longer, deeper roast profile.",
                        "Often fuller-bodied and lower in perceived acidity.",
                        "Can highlight dark cocoa, caramelized sugar, spice, smoke, and roasty sweetness."
                    ],
                    callout: "Roasting does not create quality by itself. It reveals, balances, and transforms what is already in the green coffee."
                )
            ]
        ),

        CoffeeExploreTopic(
            id: "brewing",
            title: "Brewing",
            subtitle: "Learn the basics behind making a balanced cup at home.",
            icon: "cup.and.saucer.fill",
            sections: [
                CoffeeExploreSection(
                    heading: "What Brewing Does",
                    body: "Brewing extracts flavor from ground coffee using water. A good cup depends on proportion, grind, water, freshness, time, and temperature."
                ),
                CoffeeExploreSection(
                    heading: "Core Brewing Variables",
                    bullets: [
                        "More coffee usually creates a stronger cup.",
                        "A finer grind extracts faster; a coarser grind extracts slower.",
                        "Filtered water can improve clarity and taste.",
                        "Freshly ground coffee preserves more aroma.",
                        "Brewing time affects balance, sweetness, and bitterness."
                    ]
                ),
                CoffeeExploreSection(
                    heading: "Balanced Extraction",
                    body: "Under-extracted coffee can taste sour, thin, or weak. Over-extracted coffee can taste bitter, dry, or harsh.",
                    callout: "Small changes in grind, water, or ratio can make a big difference."
                )
            ]
        ),

        CoffeeExploreTopic(
            id: "four-fundamentals",
            title: "Four Fundamentals of Brewing",
            subtitle: "Master proportion, grind, water, and freshness.",
            icon: "4.circle.fill",
            sections: [
                CoffeeExploreSection(
                    heading: "1. Proportion",
                    body: "Use the right amount of coffee for the amount of water. A common starting point is 2 Tbsp of ground coffee for every 6 fl oz of water."
                ),
                CoffeeExploreSection(
                    heading: "2. Grind",
                    body: "Match your grind to your brew method. Coffee press needs a coarse grind, while pour-over usually works best with a medium-fine grind."
                ),
                CoffeeExploreSection(
                    heading: "3. Water",
                    body: "Use fresh, filtered water when possible. For many manual brewing methods, water just off the boil works well."
                ),
                CoffeeExploreSection(
                    heading: "4. Freshness",
                    body: "Coffee tastes best when it is fresh. Store beans properly and grind close to brewing when possible.",
                    callout: "A great brew usually comes from consistency: same ratio, same grind, same water, and small adjustments."
                )
            ]
        ),

        CoffeeExploreTopic(
            id: "coffee-press",
            title: "How to Brew a Coffee Press",
            subtitle: "A full-bodied brew method that uses immersion.",
            icon: "rectangle.compress.vertical",
            sections: [
                CoffeeExploreSection(
                    heading: "What You Need",
                    bullets: [
                        "Coffee press.",
                        "Coarse ground coffee.",
                        "Hot water.",
                        "Timer.",
                        "Spoon."
                    ]
                ),
                CoffeeExploreSection(
                    heading: "Steps",
                    bullets: [
                        "Preheat the coffee press with hot water, then discard the water.",
                        "Add coarse ground coffee.",
                        "Use 2 Tbsp or 10g coffee for every 6 fl oz or 180ml water.",
                        "Pour hot water over the grounds.",
                        "Gently stir to saturate the coffee.",
                        "Place the lid on top and let it brew for about 4 minutes.",
                        "Press the plunger down slowly and serve right away."
                    ]
                ),
                CoffeeExploreSection(
                    heading: "Taste Profile",
                    body: "Coffee press brewing produces a rich, full-bodied cup because the coffee grounds stay in direct contact with the water.",
                    callout: "Best for coffees with full body and deep notes, like Sumatra or Komodo Dragon."
                )
            ]
        ),

        CoffeeExploreTopic(
            id: "pour-over",
            title: "How to Brew a Pour-Over",
            subtitle: "A clean, flavorful method that highlights clarity and aroma.",
            icon: "drop.fill",
            sections: [
                CoffeeExploreSection(
                    heading: "What You Need",
                    bullets: [
                        "Pour-over cone.",
                        "Paper filter.",
                        "Medium-fine ground coffee.",
                        "Hot water.",
                        "Mug or carafe.",
                        "Timer."
                    ]
                ),
                CoffeeExploreSection(
                    heading: "Steps",
                    bullets: [
                        "Place the filter in the cone and rinse it with hot water.",
                        "Add medium-fine ground coffee.",
                        "Use 2 Tbsp or 10g coffee for every 6 fl oz or 180ml water.",
                        "Pour a small amount of water over the grounds to saturate them.",
                        "Let the coffee bloom briefly.",
                        "Continue pouring slowly in small circles.",
                        "Allow the water to finish draining, then enjoy."
                    ]
                ),
                CoffeeExploreSection(
                    heading: "Taste Profile",
                    body: "Pour-over brewing can create a clean, bright cup that highlights delicate acidity, aroma, and flavor clarity.",
                    callout: "Great for brighter coffees like Veranda Blend, Green Apron Blend, or Guatemala Antigua."
                )
            ]
        ),

        CoffeeExploreTopic(
            id: "tasting-characteristics",
            title: "Tasting Characteristics",
            subtitle: "Build your coffee vocabulary with aroma, acidity, body, flavor, and finish.",
            icon: "text.book.closed.fill",
            sections: [
                CoffeeExploreSection(
                    heading: "Aroma",
                    body: "Aroma is what you smell before and while tasting coffee. It can remind you of flowers, citrus, chocolate, nuts, spice, herbs, or toasted sugar."
                ),
                CoffeeExploreSection(
                    heading: "Acidity",
                    body: "Acidity is the bright, lively sensation in coffee. It can feel crisp like citrus or soft like apple. Low acidity coffees often taste smoother or earthier."
                ),
                CoffeeExploreSection(
                    heading: "Body",
                    body: "Body describes the weight or texture of coffee in your mouth. A light-bodied coffee can feel delicate, while a full-bodied coffee can feel rich or syrupy."
                ),
                CoffeeExploreSection(
                    heading: "Flavor",
                    body: "Flavor includes the main notes you identify, such as cocoa, citrus, berries, nuts, caramel, spice, smoke, herbs, or brown sugar."
                ),
                CoffeeExploreSection(
                    heading: "Finish",
                    body: "Finish is the taste and texture that remains after swallowing. Some coffees finish clean and quick, while others linger with sweetness, spice, or roastiness.",
                    callout: "When tasting, avoid looking for a right answer. Focus on what you notice."
                )
            ]
        ),

        CoffeeExploreTopic(
            id: "four-steps-tasting",
            title: "Four Steps of Tasting Coffee",
            subtitle: "Use smell, slurp, locate, and describe to taste more intentionally.",
            icon: "list.number",
            sections: [
                CoffeeExploreSection(
                    heading: "1. Smell",
                    body: "Smell the coffee before tasting. Aroma gives you clues about flavor before the coffee reaches your tongue."
                ),
                CoffeeExploreSection(
                    heading: "2. Slurp",
                    body: "Slurp the coffee so it sprays across your tongue and palate. This helps you experience more aroma, texture, and flavor at once."
                ),
                CoffeeExploreSection(
                    heading: "3. Locate",
                    body: "Notice where you experience the coffee. Does it feel bright on the sides of your tongue, heavy in the center, or lingering at the finish?"
                ),
                CoffeeExploreSection(
                    heading: "4. Describe",
                    body: "Use your own words. Describe aroma, acidity, body, flavor, and finish. Compare the coffee to foods, spices, fruits, or memories.",
                    callout: "A tasting note can be simple: bright citrus, smooth cocoa, earthy spice, or sweet caramel."
                )
            ]
        ),
                
         CoffeeExploreTopic(
                    id: "coffee-list-overview",
                    title: "Coffee List Overview",
                    subtitle: "Review the coffees in your passport with roast level, origin, body, acidity, processing, and pairings.",
                    icon: "list.bullet.rectangle.fill",
                    sections: [
                        CoffeeExploreSection(
                            heading: "Sunsera Blend",
                            body: "Blonde Roast · Smooth and bright with notes of zesty citrus and toasted almond.",
                            bullets: [
                                "Origin: Brazil & Colombia",
                                "Body: Medium-Light",
                                "Acidity: Medium",
                                "Processing: Washed + Sun-Dried",
                                "Food Pairing: Blueberry Streusel Muffin, Chocolate Croissant, Toasted Almond Biscotti"
                            ]
                        ),

                        CoffeeExploreSection(
                            heading: "Veranda Blend",
                            body: "Blonde Roast · Mellow and soft with notes of toasted malt and milk chocolate.",
                            bullets: [
                                "Origin: Latin America",
                                "Body: Light",
                                "Acidity: Medium",
                                "Processing: Washed",
                                "Food Pairing: Banana Nut Bread, Madeleines, Milk Chocolate"
                            ]
                        ),

                        CoffeeExploreSection(
                            heading: "Blonde Espresso Roast",
                            body: "Blonde Roast · Smooth and subtly sweet with a balanced flavor profile.",
                            bullets: [
                                "Origin: Latin America & East Africa",
                                "Body: Light",
                                "Acidity: Medium",
                                "Processing: Washed",
                                "Food Pairing: Iced Lemon Loaf, Vanilla Scone, Cinnamon Coffee Cake"
                            ]
                        ),

                        CoffeeExploreSection(
                            heading: "Green Apron Blend",
                            body: "Blonde Roast · Lively and refreshing with notes of honeybell orange and graham cracker.",
                            bullets: [
                                "Origin: Africa & Latin America",
                                "Body: Medium",
                                "Acidity: Medium",
                                "Processing: Washed",
                                "Food Pairing: Orange Slices, Graham Crackers, Iced Lemon Loaf"
                            ]
                        ),

                        CoffeeExploreSection(
                            heading: "Siren's Blend",
                            body: "Medium Roast · Bright and lively with notes of juicy citrus and chocolate.",
                            bullets: [
                                "Origin: Latin America & Africa",
                                "Body: Medium",
                                "Acidity: Medium-High",
                                "Processing: Washed",
                                "Food Pairing: Iced Lemon Loaf, Candied Citrus, Milk Chocolate"
                            ]
                        ),

                        CoffeeExploreSection(
                            heading: "Iced Coffee Blend",
                            body: "Medium Roast · Approachable and refreshing with notes of malted milk chocolate and brown sugar.",
                            bullets: [
                                "Origin: Latin America",
                                "Body: Medium-Light",
                                "Acidity: Medium",
                                "Processing: Washed",
                                "Food Pairing: Double Chocolate Brownie, Brown Sugar Oatmeal, Iced Lemon Loaf"
                            ]
                        ),

                        CoffeeExploreSection(
                            heading: "Cold Brew Blend",
                            body: "Medium Roast · Smooth and rich with notes of cocoa and citrus.",
                            bullets: [
                                "Origin: Latin America & Africa",
                                "Body: Full",
                                "Acidity: Low",
                                "Processing: Washed",
                                "Food Pairing: Chocolate Croissant, Cinnamon Coffee Cake, Orange Slices"
                            ]
                        ),

                        CoffeeExploreSection(
                            heading: "Pike Place Roast",
                            body: "Medium Roast · Smooth and balanced with subtle notes of cocoa and toasted nuts.",
                            bullets: [
                                "Origin: Latin America",
                                "Body: Medium",
                                "Acidity: Medium",
                                "Processing: Washed",
                                "Food Pairing: Chocolate Croissant, Cinnamon Coffee Cake, Peanut Butter"
                            ]
                        ),

                        CoffeeExploreSection(
                            heading: "Guatemala Antigua",
                            body: "Medium Roast · Elegant and complex with notes of cocoa and soft spice.",
                            bullets: [
                                "Origin: Guatemala",
                                "Body: Medium",
                                "Acidity: High",
                                "Processing: Washed",
                                "Food Pairing: Chocolate Croissant, Apple Pastry, Caramel, Nuts"
                            ]
                        ),

                        CoffeeExploreSection(
                            heading: "Organic Yukon Blend",
                            body: "Medium Roast · Big, bold, and balanced with hearty herbal notes and subtle acidity.",
                            bullets: [
                                "Origin: Latin America & Asia/Pacific",
                                "Body: Full",
                                "Acidity: Medium",
                                "Processing: Washed + Semi-Washed",
                                "Food Pairing: Classic Oatmeal, Cinnamon Coffee Cake, Morning Bun"
                            ]
                        ),

                        CoffeeExploreSection(
                            heading: "Sumatra",
                            body: "Dark Roast · Earthy and herbal with rustic spice and a syrupy body.",
                            bullets: [
                                "Origin: Asia/Pacific",
                                "Body: Full",
                                "Acidity: Low",
                                "Processing: Semi-Washed",
                                "Food Pairing: Cheese Danish, Maple Bar, Oatmeal, Cinnamon"
                            ]
                        ),

                        CoffeeExploreSection(
                            heading: "Komodo Dragon",
                            body: "Dark Roast · Bold and spicy with rich herbal and cedary notes.",
                            bullets: [
                                "Origin: Asia/Pacific",
                                "Body: Full",
                                "Acidity: Low",
                                "Processing: Washed + Semi-Washed",
                                "Food Pairing: Brie Cheese, Maple Bar, Buttery Pastries, Cinnamon"
                            ]
                        ),

                        CoffeeExploreSection(
                            heading: "Cafe Verona",
                            body: "Dark Roast · Roasty and sweet with notes of dark cocoa and caramelized sugar.",
                            bullets: [
                                "Origin: Multi-region blend",
                                "Body: Full",
                                "Acidity: Low",
                                "Processing: Washed + Semi-Washed",
                                "Food Pairing: Chocolate Croissant, Chocolate Chip Cookie, Dark Chocolate"
                            ]
                        ),

                        CoffeeExploreSection(
                            heading: "Espresso Roast",
                            body: "Dark Roast · Rich and caramelly with notes of molasses and caramelized sugar.",
                            bullets: [
                                "Origin: Multi-region blend",
                                "Body: Full",
                                "Acidity: Medium",
                                "Processing: Washed",
                                "Food Pairing: Double Chocolate Brownie, Chocolate Caramels, Caramel Desserts"
                            ]
                        ),

                        CoffeeExploreSection(
                            heading: "Italian Roast",
                            body: "Dark Roast · Roasty and sweet with notes of dark cocoa and toasted marshmallow.",
                            bullets: [
                                "Origin: Multi-region blend",
                                "Body: Medium",
                                "Acidity: Low",
                                "Processing: Washed",
                                "Food Pairing: Chocolate, Caramelized Sugar, Spice Cake"
                            ],
                            callout: "This overview is a guest-friendly reference. Signed-in users can open the main Coffee List to check in coffees, favorite them, and save tasting progress."
                        )
                    ]
                )
            ]
        }
