// RFC_4122.UUID.swift
// Core 128-bit UUID type per RFC 4122

import ASCII_Primitives
import Standard_Library_Extensions

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
import Darwin_Primitives
import Darwin_Kernel_Primitives
#elseif os(Linux)
import Linux_Primitives
import Linux_Kernel_Primitives
#elseif os(Windows)
import Windows_Primitives
import Windows_Kernel_Primitives
#endif

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
        public init(_ string: Swift.String) throws(Error) {
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
    /// Parses a UUID string using native platform APIs when available.
    ///
    /// For 36-character hyphenated format, uses native `uuid_parse` (Darwin/Linux)
    /// or `UuidFromStringA` (Windows) for near-Foundation performance.
    /// Falls back to pure Swift for compact format or unsupported platforms.
    private static func parse(_ string: Swift.String) throws(Error) -> Self {
        // Try native parsing first for hyphenated format (36 chars)
        if string.utf8.count == 36 {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
            if let bytes = Darwin_Primitives.Darwin.Identity.UUID.parse(string) {
                return Self(bytes: bytes)
            }
            #elseif os(Linux)
            if let bytes = Linux_Primitives.Linux.Identity.UUID.parse(string) {
                return Self(bytes: bytes)
            }
            #elseif os(Windows)
            if let bytes = Windows_Primitives.Windows.Identity.UUID.parse(string) {
                return Self(bytes: bytes)
            }
            #endif
        }

        // Fallback to pure Swift (handles compact format + detailed errors)
        return try parseUTF8(Array(string.utf8), originalString: string)
    }

    /// Parses UUID from UTF-8 bytes.
    ///
    /// - Parameters:
    ///   - utf8: Collection of UTF-8 bytes
    ///   - originalString: Original string for error reporting
    /// - Returns: Parsed UUID
    /// - Throws: `Error` for invalid input
    private static func parseUTF8<C: Collection>(
        _ utf8: C,
        originalString: Swift.String
    ) throws(Error) -> Self where C.Element == UInt8, C.Index == Int {
        let count = utf8.count

        switch count {
        case 36:
            // Hyphenated format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
            // Validate hyphens at byte positions 8, 13, 18, 23
            let hyphen = UInt8(ascii: "-")
            guard utf8[utf8.startIndex + 8] == hyphen,
                  utf8[utf8.startIndex + 13] == hyphen,
                  utf8[utf8.startIndex + 18] == hyphen,
                  utf8[utf8.startIndex + 23] == hyphen else {
                throw .invalidFormat
            }
            return try parseHyphenatedUTF8(utf8, originalString: originalString)

        case 32:
            // Compact format: no hyphens
            return try parseCompactUTF8(utf8, originalString: originalString)

        default:
            throw .invalidLength
        }
    }

    /// Parses hyphenated format (36 bytes): xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    @inline(always)
    private static func parseHyphenatedUTF8<C: Collection>(
        _ utf8: C,
        originalString: Swift.String
    ) throws(Error) -> Self where C.Element == UInt8, C.Index == Int {
        // Hex digit positions in hyphenated format (skipping hyphens at 8, 13, 18, 23)
        // Group 1: 0-7   (8 hex digits = 4 bytes)
        // Group 2: 9-12  (4 hex digits = 2 bytes)
        // Group 3: 14-17 (4 hex digits = 2 bytes)
        // Group 4: 19-22 (4 hex digits = 2 bytes)
        // Group 5: 24-35 (12 hex digits = 6 bytes)

        let start = utf8.startIndex

        @inline(always)
        func byte(at highPos: Int, _ lowPos: Int) throws(Error) -> UInt8 {
            guard let high = ASCII.Parsing.hexDigit( utf8[start + highPos]),
                  let low = ASCII.Parsing.hexDigit( utf8[start + lowPos]) else {
                // Find which position failed for error reporting
                let failPos = ASCII.Parsing.hexDigit( utf8[start + highPos]) == nil ? highPos : lowPos
                let chars = Array(originalString)
                throw .invalidCharacter(chars[failPos], at: failPos)
            }
            return (high << 4) | low
        }

        return Self(bytes: (
            // time_low (bytes 0-3)
            try byte(at: 0, 1),
            try byte(at: 2, 3),
            try byte(at: 4, 5),
            try byte(at: 6, 7),
            // time_mid (bytes 4-5), after hyphen at 8
            try byte(at: 9, 10),
            try byte(at: 11, 12),
            // time_hi_and_version (bytes 6-7), after hyphen at 13
            try byte(at: 14, 15),
            try byte(at: 16, 17),
            // clock_seq_hi_and_reserved (byte 8), after hyphen at 18
            try byte(at: 19, 20),
            // clock_seq_low (byte 9)
            try byte(at: 21, 22),
            // node (bytes 10-15), after hyphen at 23
            try byte(at: 24, 25),
            try byte(at: 26, 27),
            try byte(at: 28, 29),
            try byte(at: 30, 31),
            try byte(at: 32, 33),
            try byte(at: 34, 35)
        ))
    }

    /// Parses compact format (32 bytes): xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    @inline(always)
    private static func parseCompactUTF8<C: Collection>(
        _ utf8: C,
        originalString: Swift.String
    ) throws(Error) -> Self where C.Element == UInt8, C.Index == Int {
        let start = utf8.startIndex

        @inline(always)
        func byte(at highPos: Int, _ lowPos: Int) throws(Error) -> UInt8 {
            guard let high = ASCII.Parsing.hexDigit( utf8[start + highPos]),
                  let low = ASCII.Parsing.hexDigit( utf8[start + lowPos]) else {
                // Find which position failed for error reporting
                let failPos = ASCII.Parsing.hexDigit( utf8[start + highPos]) == nil ? highPos : lowPos
                let chars = Array(originalString)
                throw .invalidCharacter(chars[failPos], at: failPos)
            }
            return (high << 4) | low
        }

        return Self(bytes: (
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
        ))
    }
}
