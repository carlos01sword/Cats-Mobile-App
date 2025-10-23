import SwiftUI

struct FavoritesButton: View {

    @StateObject var viewModel: DetailsViewModel
    @Environment(\.modelContext) private var context

    var body: some View {
        Button {
            viewModel.toggleFavorite(context: context)
        } label: {
            Text(viewModel.favoriteButtonLabel(context: context))
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                .frame(minWidth: .favoritesButtonMinWidth)
                .background(
                    RoundedRectangle(
                        cornerRadius: .favoritesButtonCornerRadius
                    )
                    .fill(viewModel.favoriteButtonColor(context: context))
                    .shadow()
                )
        }
        .padding(.vertical, .favoritesButtonVerticalPadding)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
    }
}

private extension CGFloat{
    static let favoritesButtonMinWidth: Self = 220
    static let favoritesButtonVerticalPadding: Self = 12
    static let favoritesButtonCornerRadius: Self = 12
}
