// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-rfc-4122",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "RFC 4122",
            targets: ["RFC 4122"]
        )
    ],
    dependencies: [
        .package(path: "../../swift-primitives/swift-ascii-primitives"),
        .package(path: "../../swift-primitives/swift-standard-library-extensions"),
        .package(path: "../../swift-primitives/swift-dependency-primitives"),
        .package(path: "../../swift-standards/swift-darwin-standard"),
        .package(path: "../../swift-linux-foundation/swift-linux-standard"),
        .package(path: "../../swift-microsoft/swift-windows-standard")
    ],
    targets: [
        .target(
            name: "RFC 4122",
            dependencies: [
                .product(name: "ASCII Primitives", package: "swift-ascii-primitives"),
                .product(name: "Standard Library Extensions", package: "swift-standard-library-extensions"),
                .product(name: "Dependency Primitives", package: "swift-dependency-primitives"),
                .product(name: "Darwin Kernel Standard", package: "swift-darwin-standard",
                         condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS])),
                .product(name: "Linux Kernel Standard", package: "swift-linux-standard",
                         condition: .when(platforms: [.linux])),
                .product(name: "Windows Kernel Standard", package: "swift-windows-standard",
                         condition: .when(platforms: [.windows]))
            ]
        ),
        .testTarget(
            name: "RFC 4122 Tests",
            dependencies: [
                "RFC 4122",
            ],
            exclude: [
                "RFC_4122.UUID Foundation Comparison Tests.swift",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
}

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
