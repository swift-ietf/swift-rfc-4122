// RFC_4122.Hash.swift
// Type-erased hash provider for RFC 4122 name-based UUID generation

public import Dependency_Primitives

#if canImport(CryptoKit)
    internal import CryptoKit
#endif

extension RFC_4122 {
    /// A type-erased hash provider for RFC 4122 name-based UUID generation.
    ///
    /// `Hash` wraps MD5 and SHA-1 hash functions for use with version 3 and
    /// version 5 UUID generation. It conforms to both ``RFC_4122/HashProvider``
    /// and ``Dependency/Key``, enabling resolution from dependency scope.
    ///
    /// ## Dependency Injection
    ///
    /// ```swift
    /// Dependency.Scope.with { $0[RFC_4122.Hash.self] = myHashProvider } operation: {
    ///     let uuid = RFC_4122.UUID.v3(namespace: .dns, name: "example.com")
    /// }
    /// ```
    public struct Hash: Sendable {
        @usableFromInline
        let _md5: @Sendable ([UInt8]) -> [UInt8]

        @usableFromInline
        let _sha1: @Sendable ([UInt8]) -> [UInt8]

        @inlinable
        public init(
            md5: @escaping @Sendable ([UInt8]) -> [UInt8],
            sha1: @escaping @Sendable ([UInt8]) -> [UInt8]
        ) {
            self._md5 = md5
            self._sha1 = sha1
        }
    }
}

// MARK: - HashProvider

extension RFC_4122.Hash: RFC_4122.HashProvider {
    @inlinable
    public func md5(_ data: [UInt8]) -> [UInt8] { _md5(data) }

    @inlinable
    public func sha1(_ data: [UInt8]) -> [UInt8] { _sha1(data) }
}

// MARK: - Dependency.Key

extension RFC_4122.Hash: Dependency.Key {
    public typealias Value = RFC_4122.Hash

    public static var liveValue: RFC_4122.Hash {
        #if canImport(CryptoKit)
            RFC_4122.Hash(
                md5: { data in
                    var hasher = Insecure.MD5()
                    data.withUnsafeBufferPointer {
                        hasher.update(bufferPointer: UnsafeRawBufferPointer($0))
                    }
                    return Array(hasher.finalize())
                },
                sha1: { data in
                    var hasher = Insecure.SHA1()
                    data.withUnsafeBufferPointer {
                        hasher.update(bufferPointer: UnsafeRawBufferPointer($0))
                    }
                    return Array(hasher.finalize())
                }
            )
        #else
            fatalError(
                "RFC_4122.Hash.liveValue unavailable on this platform. "
                    + "Inject a hash provider via Dependency.Scope.with { $0[RFC_4122.Hash.self] = ... }"
            )
        #endif
    }

    public static var testValue: RFC_4122.Hash {
        RFC_4122.Hash(
            md5: { data in
                var result = [UInt8](repeating: 0, count: 16)
                for i in 0..<min(data.count, 16) { result[i] = data[i] }
                return result
            },
            sha1: { data in
                var result = [UInt8](repeating: 0, count: 20)
                for i in 0..<min(data.count, 20) { result[i] = data[i] }
                return result
            }
        )
    }
}
