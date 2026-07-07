// RFC_4122.HashProvider.swift
// Hash provider protocol for name-based UUID generation (v3, v5)

// MARK: - Hash Provider Protocol

extension RFC_4122 {
    /// Protocol for providing hash functions to name-based UUID generators.
    ///
    /// Implement this protocol to provide MD5 (for v3) or SHA-1 (for v5)
    /// hashing capabilities without bringing in Foundation or external crypto libraries.
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct CryptoHashProvider: RFC_4122.HashProvider {
    ///     func md5(_ data: [UInt8]) -> [UInt8] {
    ///         // Return 16-byte MD5 hash
    ///     }
    ///
    ///     func sha1(_ data: [UInt8]) -> [UInt8] {
    ///         // Return 20-byte SHA-1 hash
    ///     }
    /// }
    /// ```
    public protocol HashProvider: Sendable {
        /// Computes the MD5 hash of the input data.
        ///
        /// - Parameter data: The data to hash.
        /// - Returns: A 16-byte MD5 digest.
        func md5(_ data: [UInt8]) -> [UInt8]

        /// Computes the SHA-1 hash of the input data.
        ///
        /// - Parameter data: The data to hash.
        /// - Returns: A 20-byte SHA-1 digest.
        func sha1(_ data: [UInt8]) -> [UInt8]
    }
}
