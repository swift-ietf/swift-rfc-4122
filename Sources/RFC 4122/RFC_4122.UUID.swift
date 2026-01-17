// RFC_4122.UUID.swift
// Core 128-bit UUID type per RFC 4122

extension RFC_4122 {
    /// A 128-bit universally unique identifier per RFC 4122.
    ///
    /// UUIDs are 128-bit identifiers that are unique across space and time.
    /// They consist of 16 bytes (octets) and are typically represented as
    /// 32 hexadecimal digits in the format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`
    ///
    /// This type uses tuple storage for fixed-size guarantee with no heap allocation.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Parse from string
    /// let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
    ///
    /// // Access version and variant
    /// print(uuid.version)  // Optional(.v4)
    /// print(uuid.variant)  // .rfc4122
    /// ```
    public struct UUID: Sendable {
        /// Raw 16-byte storage in big-endian (network) byte order.
        ///
        /// The bytes are arranged as specified in RFC 4122 Section 4.1.2:
        /// - Bytes 0-3: time_low
        /// - Bytes 4-5: time_mid
        /// - Bytes 6-7: time_hi_and_version
        /// - Byte 8: clock_seq_hi_and_reserved
        /// - Byte 9: clock_seq_low
        /// - Bytes 10-15: node
        public var bytes: (
            UInt8, UInt8, UInt8, UInt8,
            UInt8, UInt8, UInt8, UInt8,
            UInt8, UInt8, UInt8, UInt8,
            UInt8, UInt8, UInt8, UInt8
        )

        /// Creates a UUID from raw bytes.
        ///
        /// - Parameter bytes: 16 bytes in big-endian order.
        public init(bytes: (
            UInt8, UInt8, UInt8, UInt8,
            UInt8, UInt8, UInt8, UInt8,
            UInt8, UInt8, UInt8, UInt8,
            UInt8, UInt8, UInt8, UInt8
        )) {
            self.bytes = bytes
        }

        /// Creates a UUID by parsing a string.
        ///
        /// Accepts both hyphenated (`550e8400-e29b-41d4-a716-446655440000`)
        /// and compact (`550e8400e29b41d4a716446655440000`) formats.
        /// Parsing is case-insensitive.
        ///
        /// - Parameter string: The UUID string to parse.
        /// - Throws: `Error` if the string is not a valid UUID.
        public init(_ string: String) throws(Error) {
            self = try Self.parse(string)
        }

        /// Creates a UUID from a byte array.
        ///
        /// - Parameter bytes: An array of exactly 16 bytes.
        /// - Throws: `Error.invalidLength` if the array doesn't contain exactly 16 bytes.
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

// MARK: - Equatable & Hashable

extension RFC_4122.UUID: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        Swift.withUnsafeBytes(of: lhs.bytes) { lhsBuffer in
            Swift.withUnsafeBytes(of: rhs.bytes) { rhsBuffer in
                lhsBuffer.elementsEqual(rhsBuffer)
            }
        }
    }
}

extension RFC_4122.UUID: Hashable {
    public func hash(into hasher: inout Hasher) {
        Swift.withUnsafeBytes(of: bytes) { buffer in
            hasher.combine(bytes: buffer)
        }
    }
}

// MARK: - Byte Access

extension RFC_4122.UUID {
    /// Access byte at the given index (0-15).
    ///
    /// - Parameter index: Index from 0 to 15.
    /// - Returns: The byte at that index.
    /// - Precondition: `index` must be in range 0..<16.
    public subscript(index: Int) -> UInt8 {
        get {
            precondition(index >= 0 && index < 16, "UUID byte index out of range")
            return Swift.withUnsafeBytes(of: bytes) { $0[index] }
        }
        set {
            precondition(index >= 0 && index < 16, "UUID byte index out of range")
            Swift.withUnsafeMutableBytes(of: &bytes) { $0[index] = newValue }
        }
    }

    /// Returns the UUID bytes as an array.
    public var byteArray: [UInt8] {
        Swift.withUnsafeBytes(of: bytes) { Array($0) }
    }
}

// MARK: - Parsing

extension RFC_4122.UUID {
    /// Parses a UUID string.
    private static func parse(_ string: String) throws(Error) -> Self {
        let chars = Array(string)
        let count = chars.count

        // Determine format based on length
        switch count {
        case 36:
            // Hyphenated format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
            // Validate hyphens at positions 8, 13, 18, 23
            guard chars[8] == "-", chars[13] == "-", chars[18] == "-", chars[23] == "-" else {
                throw .invalidFormat
            }
            return try parseHexDigits(chars, hyphenated: true)

        case 32:
            // Compact format: no hyphens
            return try parseHexDigits(chars, hyphenated: false)

        default:
            throw .invalidLength
        }
    }

    private static func parseHexDigits(_ chars: [Character], hyphenated: Bool) throws(Error) -> Self {
        var bytes: [UInt8] = []
        bytes.reserveCapacity(16)

        var hexIndex = 0
        for (charIndex, char) in chars.enumerated() {
            if hyphenated && (charIndex == 8 || charIndex == 13 || charIndex == 18 || charIndex == 23) {
                continue // Skip hyphens
            }

            guard let highNibble = char.hexDigitValue else {
                throw .invalidCharacter(char, at: charIndex)
            }

            hexIndex += 1
            if hexIndex % 2 == 0 {
                continue
            }

            // Look ahead for the low nibble
            let nextCharIndex = hyphenated ? skipHyphen(charIndex + 1) : charIndex + 1
            guard nextCharIndex < chars.count else {
                throw .invalidFormat
            }

            let nextChar = chars[nextCharIndex]
            guard let lowNibble = nextChar.hexDigitValue else {
                throw .invalidCharacter(nextChar, at: nextCharIndex)
            }

            bytes.append(UInt8(highNibble << 4 | lowNibble))
        }

        guard bytes.count == 16 else {
            throw .invalidFormat
        }

        return try Self(bytes)
    }

    private static func skipHyphen(_ index: Int) -> Int {
        switch index {
        case 8, 13, 18, 23: return index + 1
        default: return index
        }
    }
}

// MARK: - Character Extension

extension Character {
    /// Returns the hex digit value (0-15) if this character is a hex digit.
    fileprivate var hexDigitValue: Int? {
        switch self {
        case "0": return 0
        case "1": return 1
        case "2": return 2
        case "3": return 3
        case "4": return 4
        case "5": return 5
        case "6": return 6
        case "7": return 7
        case "8": return 8
        case "9": return 9
        case "a", "A": return 10
        case "b", "B": return 11
        case "c", "C": return 12
        case "d", "D": return 13
        case "e", "E": return 14
        case "f", "F": return 15
        default: return nil
        }
    }
}
