// [UInt8]+RFC_4122.swift
// Byte array extensions for UUIDs

extension Array where Element == UInt8 {
    /// Creates a byte array from a UUID.
    ///
    /// The resulting array contains 16 bytes in big-endian order.
    public init(_ uuid: RFC_4122.UUID) {
        self = uuid.byteArray
    }
}

// MARK: - Unsafe Buffer Access

extension RFC_4122.UUID {
    /// Calls a closure with a pointer to the UUID's bytes.
    ///
    /// - Parameter body: A closure that takes an `UnsafeRawBufferPointer` to the 16 bytes.
    /// - Returns: The value returned by the closure.
    public func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
        try Swift.withUnsafeBytes(of: bytes, body)
    }

    /// Calls a closure with a mutable pointer to the UUID's bytes.
    ///
    /// - Parameter body: A closure that takes an `UnsafeMutableRawBufferPointer` to the 16 bytes.
    /// - Returns: The value returned by the closure.
    public mutating func withUnsafeMutableBytes<R>(
        _ body: (UnsafeMutableRawBufferPointer) throws -> R
    ) rethrows -> R {
        try Swift.withUnsafeMutableBytes(of: &bytes, body)
    }
}
