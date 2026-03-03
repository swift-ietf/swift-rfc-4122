// RFC_4122.UUID+Dependency.swift
// Convenience UUID generation methods using dependency-resolved providers

import Dependency_Primitives

// MARK: - Version 3 (MD5, resolved from context)

extension RFC_4122.UUID {
    /// Generates a version 3 UUID using the hash provider from dependency scope.
    ///
    /// Resolves ``RFC_4122/Hash`` from ``Dependency/Scope/current`` to obtain
    /// the MD5 implementation. Inject a custom provider via:
    ///
    /// ```swift
    /// Dependency.Scope.with { $0[RFC_4122.Hash.self] = myHashProvider } operation: {
    ///     let uuid = RFC_4122.UUID.v3(namespace: .dns, name: "example.com")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - namespace: The namespace UUID (e.g., `.dns`).
    ///   - name: The name to hash.
    /// - Returns: A version 3 UUID.
    public static func v3(namespace: Self, name: String) -> Self {
        v3(namespace: namespace, name: name, using: Dependency.Scope.current[RFC_4122.Hash.self])
    }

    /// Generates a version 3 UUID from raw name bytes using the hash provider
    /// from dependency scope.
    ///
    /// - Parameters:
    ///   - namespace: The namespace UUID.
    ///   - nameBytes: The name as raw bytes.
    /// - Returns: A version 3 UUID.
    public static func v3(namespace: Self, nameBytes: [UInt8]) -> Self {
        v3(namespace: namespace, nameBytes: nameBytes, using: Dependency.Scope.current[RFC_4122.Hash.self])
    }
}

// MARK: - Version 5 (SHA-1, resolved from context)

extension RFC_4122.UUID {
    /// Generates a version 5 UUID using the hash provider from dependency scope.
    ///
    /// Resolves ``RFC_4122/Hash`` from ``Dependency/Scope/current`` to obtain
    /// the SHA-1 implementation.
    ///
    /// - Parameters:
    ///   - namespace: The namespace UUID (e.g., `.dns`).
    ///   - name: The name to hash.
    /// - Returns: A version 5 UUID.
    public static func v5(namespace: Self, name: String) -> Self {
        v5(namespace: namespace, name: name, using: Dependency.Scope.current[RFC_4122.Hash.self])
    }

    /// Generates a version 5 UUID from raw name bytes using the hash provider
    /// from dependency scope.
    ///
    /// - Parameters:
    ///   - namespace: The namespace UUID.
    ///   - nameBytes: The name as raw bytes.
    /// - Returns: A version 5 UUID.
    public static func v5(namespace: Self, nameBytes: [UInt8]) -> Self {
        v5(namespace: namespace, nameBytes: nameBytes, using: Dependency.Scope.current[RFC_4122.Hash.self])
    }
}

// MARK: - Version 4 (Random, resolved from context)

extension RFC_4122.UUID {
    /// Generates a version 4 (random) UUID using the random provider from
    /// dependency scope.
    ///
    /// Resolves ``RFC_4122/Random`` from ``Dependency/Scope/current`` to obtain
    /// random bytes. The default `liveValue` uses `SystemRandomNumberGenerator`.
    ///
    /// ```swift
    /// let uuid = try RFC_4122.UUID.v4()
    /// ```
    ///
    /// - Returns: A version 4 UUID.
    /// - Throws: ``RFC_4122/Random/Error`` if random byte generation fails.
    public static func v4() throws(RFC_4122.Random.Error) -> Self {
        try v4(using: Dependency.Scope.current[RFC_4122.Random.self])
    }
}
