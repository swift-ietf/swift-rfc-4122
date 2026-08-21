import ASCII_Primitives
import Standard_Library_Extensions

extension RFC_4122 {

    public struct UUID: Sendable {

        public var bytes:
            (
                UInt8, UInt8, UInt8, UInt8,
                UInt8, UInt8, UInt8, UInt8,
                UInt8, UInt8, UInt8, UInt8,
                UInt8, UInt8, UInt8, UInt8
            )

        public init(
            bytes: (
                UInt8, UInt8, UInt8, UInt8,
                UInt8, UInt8, UInt8, UInt8,
                UInt8, UInt8, UInt8, UInt8,
                UInt8, UInt8, UInt8, UInt8
            )
        ) {
            self.bytes = bytes
        }

        public init(_ string: Swift.String) throws(Error) {
            self = try Self.parse(string)
        }

        public init(_ bytes: [UInt8]) throws(Error) {
            guard bytes.count == 16 else {
                throw .invalidLength
            }
            self.bytes = (
                bytes[0], bytes[1], bytes[2], bytes[3],
                bytes[4], bytes[5], bytes[6], bytes[7],
                bytes[8], bytes[9], bytes[10], bytes[11],
                bytes[12], bytes[13], bytes[14], bytes[15]
            )
        }
    }
}

extension RFC_4122.UUID: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        Swift.withUnsafeBytes(of: lhs.bytes) { lhsBuffer in
            Swift.withUnsafeBytes(of: rhs.bytes) { rhsBuffer in
                unsafe lhsBuffer.elementsEqual(rhsBuffer)
            }
        }
    }
}

extension RFC_4122.UUID: Hashable {
    public func hash(into hasher: inout Hasher) {
        Swift.withUnsafeBytes(of: bytes) { buffer in
            unsafe hasher.combine(bytes: buffer)
        }
    }
}

extension RFC_4122.UUID {

    public subscript(index: Int) -> UInt8 {
        get {
            precondition(index >= 0 && index < 16, "UUID byte index out of range")
            return Swift.withUnsafeBytes(of: bytes) { unsafe $0[index] }
        }
        set {
            precondition(index >= 0 && index < 16, "UUID byte index out of range")
            Swift.withUnsafeMutableBytes(of: &bytes) { unsafe $0[index] = newValue }
        }
    }

    public var byteArray: [UInt8] {
        Swift.withUnsafeBytes(of: bytes) { unsafe Array($0) }
    }
}

extension RFC_4122.UUID {

    private static func parse(_ string: Swift.String) throws(Error) -> Self {
        return try parseUTF8([Byte](string.utf8), originalString: string)
    }

    private static func parseUTF8<C: Swift.Collection>(
        _ utf8: C,
        originalString: Swift.String
    ) throws(Error) -> Self where C.Element == Byte, C.Index == Int {
        let count = utf8.count

        let arr: [ASCII.Code] = utf8.map { ASCII.Code($0.underlying) }

        switch count {
        case 36:

            guard arr[8] == ASCII.Code.hyphen,
                arr[13] == ASCII.Code.hyphen,
                arr[18] == ASCII.Code.hyphen,
                arr[23] == ASCII.Code.hyphen
            else {
                throw .invalidFormat
            }
            return try parseHyphenatedUTF8(arr, originalString: originalString)

        case 32:

            return try parseCompactUTF8(arr, originalString: originalString)

        default:
            throw .invalidLength
        }
    }

    @inline(always)
    private static func parseHyphenatedUTF8(
        _ codes: [ASCII.Code],
        originalString: Swift.String
    ) throws(Error) -> Self {

        @inline(always)
        func byte(at highPos: Int, _ lowPos: Int) throws(Error) -> UInt8 {
            guard let high = codes[highPos].hexValue,
                let low = codes[lowPos].hexValue
            else {

                let failPos = codes[highPos].hexValue == nil ? highPos : lowPos
                let chars = Array(originalString)
                throw .invalidCharacter(chars[failPos], at: failPos)
            }
            return (high << 4) | low
        }

        return Self(
            bytes: (

                try byte(at: 0, 1),
                try byte(at: 2, 3),
                try byte(at: 4, 5),
                try byte(at: 6, 7),

                try byte(at: 9, 10),
                try byte(at: 11, 12),

                try byte(at: 14, 15),
                try byte(at: 16, 17),

                try byte(at: 19, 20),

                try byte(at: 21, 22),

                try byte(at: 24, 25),
                try byte(at: 26, 27),
                try byte(at: 28, 29),
                try byte(at: 30, 31),
                try byte(at: 32, 33),
                try byte(at: 34, 35)
            )
        )
    }

    @inline(always)
    private static func parseCompactUTF8(
        _ codes: [ASCII.Code],
        originalString: Swift.String
    ) throws(Error) -> Self {
        @inline(always)
        func byte(at highPos: Int, _ lowPos: Int) throws(Error) -> UInt8 {
            guard let high = codes[highPos].hexValue,
                let low = codes[lowPos].hexValue
            else {

                let failPos = codes[highPos].hexValue == nil ? highPos : lowPos
                let chars = Array(originalString)
                throw .invalidCharacter(chars[failPos], at: failPos)
            }
            return (high << 4) | low
        }

        return Self(
            bytes: (
                try byte(at: 0, 1),
                try byte(at: 2, 3),
                try byte(at: 4, 5),
                try byte(at: 6, 7),
                try byte(at: 8, 9),
                try byte(at: 10, 11),
                try byte(at: 12, 13),
                try byte(at: 14, 15),
                try byte(at: 16, 17),
                try byte(at: 18, 19),
                try byte(at: 20, 21),
                try byte(at: 22, 23),
                try byte(at: 24, 25),
                try byte(at: 26, 27),
                try byte(at: 28, 29),
                try byte(at: 30, 31)
            )
        )
    }
}
