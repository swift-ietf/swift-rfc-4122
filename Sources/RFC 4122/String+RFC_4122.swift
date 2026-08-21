import ASCII_Primitives

extension RFC_4122.UUID: CustomStringConvertible {

    public var description: String {
        string(.hyphenated, uppercase: false)
    }
}

extension RFC_4122.UUID {

    public enum Format: Sendable {

        case hyphenated

        case compact
    }

    public func string(_ format: Format, uppercase: Bool = false) -> String {

        @inline(always)
        func hex(_ nibble: UInt8) -> UInt8 {
            uppercase
                ? ASCII.Hexadecimal.code(nibble, case: .upper)!.underlying
                : ASCII.Hexadecimal.code(nibble, case: .lower)!.underlying
        }

        let capacity = format == .hyphenated ? 36 : 32
        let hyphen: UInt8 = 0x2D

        return String(unsafeUninitializedCapacity: capacity) { buffer in
            var i = 0

            @inline(always)
            func writeByte(_ byte: UInt8) {
                unsafe buffer[i] = hex(byte >> 4)
                unsafe buffer[i + 1] = hex(byte & 0x0F)
                i += 2
            }

            @inline(always)
            func writeHyphen() {
                unsafe buffer[i] = hyphen
                i += 1
            }

            Swift.withUnsafeBytes(of: bytes) { rawBytes in
                if format == .hyphenated {

                    unsafe writeByte(rawBytes[0])
                    unsafe writeByte(rawBytes[1])
                    unsafe writeByte(rawBytes[2])
                    unsafe writeByte(rawBytes[3])
                    writeHyphen()

                    unsafe writeByte(rawBytes[4])
                    unsafe writeByte(rawBytes[5])
                    writeHyphen()

                    unsafe writeByte(rawBytes[6])
                    unsafe writeByte(rawBytes[7])
                    writeHyphen()

                    unsafe writeByte(rawBytes[8])
                    unsafe writeByte(rawBytes[9])
                    writeHyphen()

                    unsafe writeByte(rawBytes[10])
                    unsafe writeByte(rawBytes[11])
                    unsafe writeByte(rawBytes[12])
                    unsafe writeByte(rawBytes[13])
                    unsafe writeByte(rawBytes[14])
                    unsafe writeByte(rawBytes[15])
                } else {

                    (0..<16).forEach { unsafe writeByte(rawBytes[$0]) }
                }
            }

            return i
        }
    }
}

extension String {

    public init(_ uuid: RFC_4122.UUID) {
        self = uuid.description
    }
}
