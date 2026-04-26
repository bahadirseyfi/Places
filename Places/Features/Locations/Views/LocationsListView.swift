import SwiftUI

struct LocationsListView: View {
    @State var viewModel: LocationsListViewModel
    @State private var showCustomLocation = false

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Places")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Custom Location") {
                            showCustomLocation = true
                        }
                        .accessibilityIdentifier("custom_location_button")
                    }
                }
                .sheet(isPresented: $showCustomLocation) {
                    CustomLocationView(viewModel: viewModel)
                }
                .alert("Wikipedia Not Available", isPresented: $viewModel.showWikiUnavailableAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("Wikipedia app is not available on this device. Please install and run the modified Wikipedia app first.")
                }
        }
        .task {
            await viewModel.loadLocations()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView("Loading...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded(let locations):
            List(locations) { location in
                Button {
                    Task { await viewModel.openLocation(location) }
                } label: {
                    LocationRowView(location: location)
                }
                .buttonStyle(.plain)
            }
            .accessibilityIdentifier("locations_list")
        case .empty:
            ContentUnavailableView("No Locations", systemImage: "mappin.slash", description: Text("No locations were found."))
        case .failed(let message):
            VStack(spacing: 16) {
                Text(message)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Button("Retry") {
                    Task { await viewModel.retry() }
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("retry_button")
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
