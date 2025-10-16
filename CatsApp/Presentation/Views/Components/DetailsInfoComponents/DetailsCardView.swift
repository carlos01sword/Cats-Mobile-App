import SwiftUI

struct DetailsCardView: View {
    let origin: String
    let temperament: String
    let breedDescription: String

    var body: some View {
        VStack(alignment: .leading, spacing: ConstantsUI.largeVerticalSpacing) {
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
            RoundedRectangle(cornerRadius: ConstantsUI.largeCornerRadius, style: .continuous)
                .fill(Color(.secondarySystemBackground))
                .applyShadow()
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
