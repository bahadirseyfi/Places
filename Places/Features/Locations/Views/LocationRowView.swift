import SwiftUI

struct LocationRowView: View {
    let location: Location

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(location.name ?? "Unnamed location")
                .font(.body)
                .foregroundStyle(.primary)
            Text(coordinateText)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(location.name ?? "Unnamed location")
        .accessibilityValue("Latitude \(location.latitude), longitude \(location.longitude)")
        .accessibilityHint("Opens this location in Wikipedia")
    }

    private var coordinateText: String {
        String(format: "%.4f, %.4f", location.latitude, location.longitude)
    }
}
