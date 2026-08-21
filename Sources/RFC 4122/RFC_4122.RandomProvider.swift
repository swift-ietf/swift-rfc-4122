extension RFC_4122 {

    public protocol RandomProvider: Sendable {

        associatedtype RandomError: Swift.Error

        func fill(_ buffer: UnsafeMutableRawBufferPointer) throws(RandomError)
    }
}
