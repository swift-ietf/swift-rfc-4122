// RFC_4122.Random.swift
// Type-erased random byte provider for RFC 4122 UUID generation

public import Dependency_Primitives

extension RFC_4122 {
    /// A type-erased random byte provider for RFC 4122 UUID generation.
    ///
    /// `Random` wraps a function that fills a buffer with random bytes,
    /// for use with version 4 UUID generation. It conforms to both
    /// ``RFC_4122/RandomProvider`` and ``Dependency/Key``.
    ///
    /// ## Dependency Injection
    ///
    /// ```swift
    /// // Use platform random (default liveValue)
    /// let uuid = try RFC_4122.UUID.v4()
    ///
    /// // Inject deterministic random for testing
    /// Dependency.Scope.with { $0[RFC_4122.Random.self] = myRandom } operation: {
    ///     let uuid = try RFC_4122.UUID.v4()
    /// }
    /// ```
    public struct Random: Sendable {
        @usableFromInline
        let _fill: @Sendable (UnsafeMutableRawBufferPointer) throws(Error) -> Void

        @inlinable
        public init(
            fill: @escaping @Sendable (UnsafeMutableRawBufferPointer) throws(Error) -> Void
        ) {
            self._fill = fill
        }
    }
}

// MARK: - RandomProvider

extension RFC_4122.Random: RFC_4122.RandomProvider {
    public typealias RandomError = Error

    @inlinable
    public func fill(_ buffer: UnsafeMutableRawBufferPointer) throws(Error) {
        try _fill(buffer)
    }
}

// MARK: - Dependency.Key

extension RFC_4122.Random: Dependency.Key {
    public typealias Value = RFC_4122.Random

    /// - Important: `RFC_4122.Random.liveValue` traps at the L2 spec layer.
    ///   The L2 RFC 4122 encoding parameterises over a random source; the
    ///   platform CSPRNG binding lives at L3 in the `swift-uuids` unifier
    ///   per [PLAT-ARCH-009]. To generate a v4 UUID with the platform
    ///   CSPRNG, depend on `swift-uuids` and call `RFC_4122.UUID.v4()`.
    ///   Power users at L2 may inject an explicit `RFC_4122.Random` via
    ///   `Dependency.Scope.with` for testing or alternative random sources.
    public static var liveValue: RFC_4122.Random {
        fatalError(
            "RFC_4122.Random.liveValue must be bound by an L3 unifier; consume swift-uuids instead"
        )
    }

    public static var testValue: RFC_4122.Random {
        RFC_4122.Random { buffer in
            for i in buffer.indices {
                buffer[i] = UInt8(truncatingIfNeeded: i)
            }
        }
    }
}
