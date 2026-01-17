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
        .package(path: "../../swift-foundations/swift-testing-extras"),
    ],
    targets: [
        .target(
            name: "RFC 4122"
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
