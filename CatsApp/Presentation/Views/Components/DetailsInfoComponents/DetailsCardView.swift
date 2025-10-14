import SwiftUI

struct DetailsCardView: View {
    let origin: String
    let temperament: String
    let breedDescription: String

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Origin:")
                .font(.headline)
            Text(origin)
                .font(.body)
            Text("Temperament:")
                .font(.headline)
            Text(temperament)
                .font(.body)
            Text("Description:")
                .font(.headline)
            Text(breedDescription)
                .font(.body)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
}

#Preview {
    DetailsCardView(
        origin: "United States",
        temperament: "Affectionate, Curious",
        breedDescription: "A friendly and playful breed."
    )
}
