// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Fdy",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(name: "Fdy", targets: ["Fdy"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Fdy",
            dependencies: [],
            path: "Sources/Fdy",
            swiftSettings: [
                .swiftLanguageMode(.v5),
            ]
        ),
    ]
)
