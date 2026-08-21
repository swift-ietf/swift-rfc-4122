public import Dependency_Primitives

#if canImport(CryptoKit)
    internal import CryptoKit
#endif

extension RFC_4122 {

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

extension RFC_4122.Hash: RFC_4122.HashProvider {
    @inlinable
    public func md5(_ data: [UInt8]) -> [UInt8] { _md5(data) }

    @inlinable
    public func sha1(_ data: [UInt8]) -> [UInt8] { _sha1(data) }
}

extension RFC_4122.Hash: Dependency.Key {
    public typealias Value = RFC_4122.Hash

    public static var liveValue: RFC_4122.Hash {
        #if canImport(CryptoKit)
            RFC_4122.Hash(
                md5: { data in
                    var hasher = Insecure.MD5()
                    data.withUnsafeBufferPointer {
                        unsafe hasher.update(bufferPointer: UnsafeRawBufferPointer($0))
                    }
                    return Array(hasher.finalize())
                },
                sha1: { data in
                    var hasher = Insecure.SHA1()
                    data.withUnsafeBufferPointer {
                        unsafe hasher.update(bufferPointer: UnsafeRawBufferPointer($0))
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
                (0..<min(data.count, 16)).forEach { result[$0] = data[$0] }
                return result
            },
            sha1: { data in
                var result = [UInt8](repeating: 0, count: 20)
                (0..<min(data.count, 20)).forEach { result[$0] = data[$0] }
                return result
            }
        )
    }
}
