# swift-rfc-4122

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Generation and parsing of UUIDs as defined by RFC 4122.

## Standard Reference

- **RFC**: 4122
- **Title**: A Universally Unique IDentifier (UUID) URN Namespace

## Installation

Add the package to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/swift-ietf/swift-rfc-4122.git", branch: "main")
]
```

Add the product to a target that needs it:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "RFC 4122", package: "swift-rfc-4122")
    ]
)
```

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
