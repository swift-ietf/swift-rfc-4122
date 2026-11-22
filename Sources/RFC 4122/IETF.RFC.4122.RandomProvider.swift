extension IETF.RFC.`4122` {

    public protocol RandomProvider: Sendable {

        associatedtype RandomError: Swift::Error

        func fill(_ buffer: UnsafeMutableRawBufferPointer) throws(RandomError)
    }
}
