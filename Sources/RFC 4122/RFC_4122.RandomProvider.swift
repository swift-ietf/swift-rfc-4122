// RFC_4122.RandomProvider.swift
// Random provider protocol for v4 UUID generation

// MARK: - Random Provider Protocol

extension RFC_4122 {
    /// Protocol for providing random bytes to UUID generators.
    ///
    /// Implement this protocol to provide cryptographically secure random bytes
    /// for v4 UUID generation. The implementation should use a CSPRNG.
    public protocol RandomProvider: Sendable {
        /// Error type thrown by the random provider.
        associatedtype RandomError: Error

        /// Fills the buffer with cryptographically secure random bytes.
        func fill(_ buffer: UnsafeMutableRawBufferPointer) throws(RandomError)
    }
}
