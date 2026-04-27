import SwiftUI

struct CustomLocationView: View {
    @State var viewModel: LocationsListViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var latitude = ""
    @State private var longitude = ""

    private let validator = LocationValidator()

    var body: some View {
        NavigationStack {
            Form {
                Section("Location") {
                    TextField("Name (optional)", text: $name)
                        .accessibilityIdentifier("name_text_field")
                        .accessibilityLabel("Location name")

                    TextField("Latitude", text: $latitude)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("latitude_text_field")
                        .accessibilityLabel("Latitude")

                    TextField("Longitude", text: $longitude)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("longitude_text_field")
                        .accessibilityLabel("Longitude")
                }

                if !latitude.isEmpty && !validator.isValidLatitude(latitude) {
                    Text("Latitude must be between -90 and 90.")
                        .foregroundStyle(.red)
                        .font(.caption)
                }

                if !longitude.isEmpty && !validator.isValidLongitude(longitude) {
                    Text("Longitude must be between -180 and 180.")
                        .foregroundStyle(.red)
                        .font(.caption)
                }
            }
            .navigationTitle("Custom Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Open in Wikipedia") {
                        guard let lat = Double(latitude), let lon = Double(longitude) else { return }
                        Task {
                            await viewModel.openInWikipedia(
                                latitude: lat,
                                longitude: lon,
                                name: name.isEmpty ? nil : name
                            )
                            dismiss()
                        }
                    }
                    .accessibilityIdentifier("open_in_wikipedia_button")
                    .disabled(!isInputValid)
                }
            }
        }
    }

    private var isInputValid: Bool {
        validator.isValid(latitude: latitude, longitude: longitude)
    }
}
