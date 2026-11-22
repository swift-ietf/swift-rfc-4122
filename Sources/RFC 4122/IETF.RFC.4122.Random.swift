public import Dependency

extension IETF.RFC.`4122` {

    @safe public struct Random: Sendable {
        @usableFromInline
        let _fill: @Sendable (UnsafeMutableRawBufferPointer) throws(Error) -> Void

        @inlinable
        public init(
            fill: @escaping @Sendable (UnsafeMutableRawBufferPointer) throws(Error) -> Void
        ) {
            unsafe self._fill = unsafe fill
        }
    }
}

extension IETF.RFC.`4122`.Random: IETF.RFC.`4122`.RandomProvider {
    public typealias RandomError = IETF.RFC.`4122`.Random.Error

    @inlinable
    public func fill(_ buffer: UnsafeMutableRawBufferPointer) throws(Error) {
        try unsafe _fill(buffer)
    }
}

extension IETF.RFC.`4122`.Random: Dependency.Key {
    public typealias Value = IETF.RFC.`4122`.Random

    public static var liveValue: IETF.RFC.`4122`.Random {
        unsafe IETF.RFC.`4122`.Random { _ throws(Error) in
            throw .unbound
        }
    }

    public static var testValue: IETF.RFC.`4122`.Random {
        unsafe IETF.RFC.`4122`.Random { buffer in
            for i in buffer.indices {
                unsafe buffer[i] = UInt8(truncatingIfNeeded: i)
            }
        }
    }
}
