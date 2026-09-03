// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-rfc-4122",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "RFC 4122",
            targets: ["RFC 4122"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-ascii.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-standard-library-extensions.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-dependency.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "RFC 4122",
            dependencies: [
                .product(name: "ASCII", package: "swift-ascii"),
                .product(
                    name: "Standard Library Extensions",
                    package: "swift-standard-library-extensions"
                ),
                .product(name: "Dependency", package: "swift-dependency"),
            ]
        ),
        .testTarget(
            name: "RFC 4122 Tests",
            dependencies: [
                .target(name: "RFC 4122")
            ],
            exclude: [
                "RFC_4122.UUID Foundation Comparison Tests.swift"
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
