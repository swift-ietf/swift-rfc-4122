extension Array where Element == UInt8 {

    public init(_ uuid: RFC_4122.UUID) {
        self = uuid.byteArray
    }
}

extension RFC_4122.UUID {

    public func withUnsafeBytes<R, E: Swift.Error>(
        _ body: (UnsafeRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {
        try Swift.withUnsafeBytes(of: bytes, body)
    }

    public mutating func withUnsafeMutableBytes<R, E: Swift.Error>(
        _ body: (UnsafeMutableRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {
        try Swift.withUnsafeMutableBytes(of: &bytes, body)
    }
}
