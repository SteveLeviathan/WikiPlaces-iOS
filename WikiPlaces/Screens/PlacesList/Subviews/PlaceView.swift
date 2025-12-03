import SwiftUI

struct PlaceView: View {
    let placeName: String
    let latitude: Double
    let longitude: Double

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            // Location pin image
            Image(systemName: "mappin.and.ellipse")
                .foregroundStyle(Color.accentColor)
                .font(.largeTitle)

            GrayDivider()
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 12) {
                Text(placeName)
                    .foregroundStyle(.black.opacity(0.7))
                    .font(.headline)

                GrayDivider()

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Latitude:")
                            .frame(width: 75, alignment: .leading)
                        Text("\(latitude)")
                    }

                    HStack {
                        Text("Longitude:")
                            .frame(width: 75, alignment: .leading)
                        Text("\(longitude)")
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.gray)
            }

            Spacer()

            // Arrow indicating external navigation
            Image(systemName: "rectangle.portrait.and.arrow.right")
                .foregroundStyle(.black.opacity(0.5))
                .font(.headline)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black.opacity(0.3), lineWidth: 1)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(placeName)")
        .accessibilityValue("Latitude \(latitude), Longitude \(longitude)")
        .accessibilityHint("Tap to open coordinates in the Wikipedia app's Places screen")
        .accessibilityAddTraits(.isButton)
    }
}
