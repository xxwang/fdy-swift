// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Dy",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(name: "Dy", targets: ["Dy"]),
        .library(name: "DyCore", targets: ["DyCore"]),
        .library(name: "DyCombineCocoa", targets: ["DyCombineCocoa"]),
        .library(name: "DyLogger", targets: ["DyLogger"]),

    ],
    dependencies: [],
    targets: [
        .target(
            name: "Dy",
            dependencies: [
                .target(name: "DyCore"),
                .target(name: "DyCombineCocoa"),
                .target(name: "DyLogger"),
            ],
            path: "Sources/Dy",
            swiftSettings: [
                .swiftLanguageMode(.v5),
            ]
        ),
        .target(
            name: "DyCore",
            path: "Sources/Core",
            swiftSettings: [
                .swiftLanguageMode(.v5),
            ]
        ),
        .target(
            name: "DyCombineCocoa",
            path: "Sources/CombineCocoa",
            swiftSettings: [
                .swiftLanguageMode(.v5),
            ]
        ),
        .target(
            name: "DyLogger",
            path: "Sources/Logger",
            swiftSettings: [
                .swiftLanguageMode(.v5),
            ]
        ),
    ]
)
