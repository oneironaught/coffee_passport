import SwiftUI

struct GuestExploreView: View {
    private let topics = CoffeeExploreLibrary.topics

    private let columns = [
        GridItem(.adaptive(minimum: 155), spacing: 14)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                guestHeader

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
        .navigationTitle("Guest Explore")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.starbucksGreen.ignoresSafeArea())
    }

    private var guestHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle.badge.questionmark")
                    .font(.largeTitle)
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Continue as Guest")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    Text("Explore coffee education without signing in.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))
                }
            }

            Text("Learn about growing regions, sourcing, farmer support, sustainability, roasting, brewing, and coffee tasting. You can sign in later to personalize your passport experience.")
                .font(.body)
                .foregroundColor(.white.opacity(0.88))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}
