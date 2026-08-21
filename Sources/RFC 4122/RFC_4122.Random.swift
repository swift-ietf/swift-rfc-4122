public import Dependency_Primitives

extension RFC_4122 {

    public struct Random: Sendable {
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

extension RFC_4122.Random: RFC_4122.RandomProvider {
    public typealias RandomError = RFC_4122.Random.Error

    @inlinable
    public func fill(_ buffer: UnsafeMutableRawBufferPointer) throws(Error) {
        try unsafe _fill(buffer)
    }
}

extension RFC_4122.Random: Dependency.Key {
    public typealias Value = RFC_4122.Random

    public static var liveValue: RFC_4122.Random {
        fatalError(
            "RFC_4122.Random.liveValue must be bound by an L3 unifier; consume swift-uuids instead"
        )
    }

    public static var testValue: RFC_4122.Random {
        unsafe RFC_4122.Random { buffer in
            for i in buffer.indices {
                unsafe buffer[i] = UInt8(truncatingIfNeeded: i)
            }
        }
    }
}
