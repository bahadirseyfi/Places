// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NetworkPackage",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "NetworkPackage", targets: ["NetworkPackage"]),
    ],
    targets: [
        .target(name: "NetworkPackage"),
        .testTarget(name: "NetworkPackageTests", dependencies: ["NetworkPackage"]),
    ]
)
