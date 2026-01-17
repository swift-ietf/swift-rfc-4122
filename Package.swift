// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-rfc-4122",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "RFC 4122",
            targets: ["RFC 4122"]
        )
    ],
    dependencies: [
        .package(path: "../../swift-foundations/swift-ascii"),
        .package(path: "../../swift-foundations/swift-testing-extras"),
        .package(path: "../../swift-primitives/swift-standard-library-extensions"),
        .package(path: "../../swift-primitives/swift-darwin-primitives"),
        .package(path: "../../swift-primitives/swift-linux-primitives"),
        .package(path: "../../swift-primitives/swift-windows-primitives"),
    ],
    targets: [
        .target(
            name: "RFC 4122",
            dependencies: [
                .product(name: "ASCII", package: "swift-ascii"),
                .product(name: "Standard Library Extensions", package: "swift-standard-library-extensions"),
                .product(name: "Darwin Primitives", package: "swift-darwin-primitives",
                         condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS])),
                .product(name: "Darwin Kernel Primitives", package: "swift-darwin-primitives",
                         condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS])),
                .product(name: "Linux Primitives", package: "swift-linux-primitives",
                         condition: .when(platforms: [.linux])),
                .product(name: "Linux Kernel Primitives", package: "swift-linux-primitives",
                         condition: .when(platforms: [.linux])),
                .product(name: "Windows Primitives", package: "swift-windows-primitives",
                         condition: .when(platforms: [.windows])),
                .product(name: "Windows Kernel Primitives", package: "swift-windows-primitives",
                         condition: .when(platforms: [.windows])),
            ]
        ),
        .testTarget(
            name: "RFC 4122".tests,
            dependencies: [
                "RFC 4122",
                .product(name: "Testing Extras", package: "swift-testing-extras"),
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
}

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let existing = target.swiftSettings ?? []
    target.swiftSettings = existing + [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility")
    ]
}
