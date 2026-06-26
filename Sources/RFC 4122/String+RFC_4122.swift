// String+RFC_4122.swift
// String representation and formatting for UUIDs

import ASCII_Primitives

extension RFC_4122.UUID: CustomStringConvertible {
    /// The UUID as a lowercase hyphenated string.
    ///
    /// Format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`
    ///
    /// Example: `"550e8400-e29b-41d4-a716-446655440000"`
    public var description: String {
        string(.hyphenated, uppercase: false)
    }
}

extension RFC_4122.UUID {
    /// Format options for UUID string representation.
    public enum Format: Sendable {
        /// Hyphenated format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` (36 characters)
        case hyphenated

        /// Compact format: `xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx` (32 characters)
        case compact
    }

    /// Returns the UUID as a string in the specified format.
    ///
    /// Uses optimized UTF-8 byte output with static lookup tables.
    ///
    /// - Parameters:
    ///   - format: The output format (hyphenated or compact).
    ///   - uppercase: Whether to use uppercase hex digits (default: false).
    /// - Returns: The formatted UUID string.
    public func string(_ format: Format, uppercase: Bool = false) -> String {
        // Per-nibble delegation to the L1 single-byte ASCII hex serializers.
        // Uppercase branch → hexDigitUppercase (0-9, A-F); lowercase branch →
        // hexDigitLowercase (0-9, a-f) — byte-identical to the former static
        // tables. Each nibble is masked to 0-15 at the call site (byte >> 4,
        // byte & 0x0F), so the 0-15 domain is structurally guaranteed and the
        // force-unwrap is total (the prior tuple indexing trapped likewise).
        @inline(always)
        func hex(_ nibble: UInt8) -> UInt8 {
            uppercase
                ? ASCII.Serialization.hexDigitUppercase(nibble)!.underlying
                : ASCII.Serialization.hexDigitLowercase(nibble)!.underlying
        }

        let capacity = format == .hyphenated ? 36 : 32
        let hyphen: UInt8 = 0x2D  // '-'

        return String(unsafeUninitializedCapacity: capacity) { buffer in
            var i = 0

            @inline(always)
            func writeByte(_ byte: UInt8) {
                buffer[i] = hex(byte >> 4)
                buffer[i + 1] = hex(byte & 0x0F)
                i += 2
            }

            @inline(always)
            func writeHyphen() {
                buffer[i] = hyphen
                i += 1
            }

            // Access bytes via withUnsafeBytes to avoid byteArray allocation
            Swift.withUnsafeBytes(of: bytes) { rawBytes in
                if format == .hyphenated {
                    // time_low (4 bytes)
                    writeByte(rawBytes[0])
                    writeByte(rawBytes[1])
                    writeByte(rawBytes[2])
                    writeByte(rawBytes[3])
                    writeHyphen()
                    // time_mid (2 bytes)
                    writeByte(rawBytes[4])
                    writeByte(rawBytes[5])
                    writeHyphen()
                    // time_hi_and_version (2 bytes)
                    writeByte(rawBytes[6])
                    writeByte(rawBytes[7])
                    writeHyphen()
                    // clock_seq_hi_and_reserved + clock_seq_low (2 bytes)
                    writeByte(rawBytes[8])
                    writeByte(rawBytes[9])
                    writeHyphen()
                    // node (6 bytes)
                    writeByte(rawBytes[10])
                    writeByte(rawBytes[11])
                    writeByte(rawBytes[12])
                    writeByte(rawBytes[13])
                    writeByte(rawBytes[14])
                    writeByte(rawBytes[15])
                } else {
                    // Compact format: all 16 bytes, no hyphens
                    for byteIndex in 0..<16 {
                        writeByte(rawBytes[byteIndex])
                    }
                }
            }

            return i
        }
    }
}

// MARK: - String Conversion

extension String {
    /// Creates a string from a UUID.
    ///
    /// The resulting string is in lowercase hyphenated format.
    public init(_ uuid: RFC_4122.UUID) {
        self = uuid.description
    }
}
