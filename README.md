# ABN AMRO iOS Assignment

This is my solution for the ABN AMRO iOS assignment. The project has two parts:

1. **Places app** — a simple SwiftUI app that shows a list of locations
2. **Wikipedia app** — the original Wikipedia iOS app, modified to support a new deep link

---

## How It Works

The Places app fetches a list of locations from a remote URL. When the user taps a location, the app opens the Wikipedia app and navigates directly to the Places tab, centered on that location.

I also added a "Custom Location" button so the user can type any coordinates and open Wikipedia there.

---

## Project Structure

```
abn-assignment/
├── Places/               # The test app (SwiftUI)
└── wikipedia-ios/        # The modified Wikipedia app
```

---

## Places App

### Features

- Fetches locations from the API and shows them in a list
- Tapping a location opens Wikipedia at that place
- "Custom Location" button lets the user enter latitude and longitude manually
- Shows an error message if the network request fails, with a retry button
- Shows an alert if the Wikipedia app is not installed

### Architecture

I used **MVVM** pattern with **protocol-based dependency injection**. This makes the code easier to test because I can replace real services with mock objects in tests.

```
Features/Locations/
├── Models/          # Location data model and service
├── ViewModels/      # LocationsListViewModel
├── Views/           # SwiftUI views
└── Routing/         # Deep link builder and router
```

### Tech Choices

- **SwiftUI** for all UI
- **async/await** for network calls and navigation
- **@Observable** for the view model (instead of ObservableObject)
- **Swift Testing** framework for unit tests (`@Test`, `@Suite`)
- **Protocols** for all dependencies so they can be mocked in tests

### How to Run

1. Open `Places/Places.xcodeproj` in Xcode
2. Make sure the Wikipedia app is installed on the same simulator (see below)
3. Run the Places app
4. Tap any location — Wikipedia should open on the Places tab

---

## Wikipedia App Changes

I modified `NSUserActivity+WMFExtensions.m` to handle a new deep link format:

```
wikipedia://namedPlace?latitude=52.3547498&longitude=4.8339215&locationName=Amsterdam
```

When the app receives this URL:

1. It parses the `latitude`, `longitude`, and optional `locationName` from the query parameters
2. It validates the coordinate values (latitude must be between -90 and 90, longitude between -180 and 180)
3. It navigates to the Places tab
4. It centers the map on the given coordinate

The main files I changed or added logic to:

- `Wikipedia/Code/NSUserActivity+WMFExtensions.m` — added `wmf_namedPlaceActivityWithURL:` method
- `Wikipedia/Code/WMFAppViewController.m` — added handling for `WMFUserActivityTypeNamedPlace`
- `Wikipedia/Code/PlacesViewController.swift` — added `showCoordinate(_:locationName:)` method

### How to Build Wikipedia App

1. Open `wikipedia-ios/Wikipedia.xcodeproj` in Xcode
2. Select a simulator (same one you will use for Places app)
3. Build and run once so it is installed on the simulator
4. You do not need to keep it running — Places app will open it via deep link

---

## Tests

### Unit Tests

I wrote unit tests for the main parts of the Places app:

| Test File | What It Tests |
|---|---|
| `LocationDecodingTests` | JSON decoding, especially the `lat`/`long` key mapping |
| `LocationValidatorTests` | Coordinate validation (valid ranges, empty input, non-numeric input) |
| `LocationsServiceTests` | Network fetching and retry logic |
| `LocationsListViewModelTests` | State transitions (loading, loaded, failed) and navigation |
| `DeeplinkBuilderTests` | URL building, query parameters, special character encoding |

### UI Tests

I added UI tests that use launch arguments to inject a stub service. This way the tests do not need a real network connection.

```swift
// Example: launch with stub locations
app.launchArguments = ["-uiTestMode"]
```

---

## Accessibility

- All interactive elements have `accessibilityIdentifier` (used in UI tests)
- Location rows have `accessibilityLabel` and `accessibilityHint`
- The custom location form fields have proper `accessibilityLabel` values

---

## Requirements Checklist

- [x] SwiftUI for the Places app
- [x] Fetch locations from the given URL
- [x] Tap a location to open Wikipedia at that place
- [x] Custom location input
- [x] Wikipedia app modified to support coordinate deep link
- [x] Unit tests
- [x] Swift Concurrency (async/await, Sendable, @Observable)
- [x] Accessibility support
- [x] README (this file)
