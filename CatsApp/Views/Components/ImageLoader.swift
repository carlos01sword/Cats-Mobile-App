import SwiftUI

struct ImageLoader: View {

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: ConstantsUI.defaultCornerRadius, style: .continuous)
                .fill(ConstantsUI.shimmerBaseColor)
            ProgressView()
                .progressViewStyle(.circular)
        }
        .accessibilityHidden(true)
    }
}

#if DEBUG
private extension CGFloat {
    static let previewFrame: Self = 120
}

#Preview {
    ImageLoader()
        .frame(width: .previewFrame, height: .previewFrame)
        .padding()
}
#endif
