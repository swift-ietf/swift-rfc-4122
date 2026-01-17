// RFC_4122.UUID.Variant.swift
// UUID variant field per RFC 4122 Section 4.1.1

extension RFC_4122.UUID {
    /// The UUID variant as defined in RFC 4122 Section 4.1.1.
    ///
    /// The variant field determines the layout of the UUID.
    /// The variant is encoded in the most significant bits of byte 8.
    public enum Variant: Sendable, Hashable {
        /// Reserved for NCS backward compatibility (0xx).
        ///
        /// High bit pattern: `0xx` (bits 7-5 of byte 8).
        case ncs

        /// The variant specified in RFC 4122 (10x).
        ///
        /// This is the standard variant for UUIDs generated according to RFC 4122.
        /// High bit pattern: `10x` (bits 7-5 of byte 8).
        case rfc4122

        /// Reserved for Microsoft backward compatibility (110).
        ///
        /// High bit pattern: `110` (bits 7-5 of byte 8).
        case microsoft

        /// Reserved for future definition (111).
        ///
        /// High bit pattern: `111` (bits 7-5 of byte 8).
        case future
    }

    /// The variant of this UUID.
    ///
    /// The variant is determined by examining the most significant bits of byte 8:
    /// - `0xx`: NCS backward compatibility
    /// - `10x`: RFC 4122 (standard)
    /// - `110`: Microsoft backward compatibility
    /// - `111`: Reserved for future definition
    public var variant: Variant {
        let byte = bytes.8

        // Check high bits of byte 8
        // 0xx = NCS
        if byte & 0x80 == 0 {
            return .ncs
        }
        // 10x = RFC 4122
        if byte & 0xC0 == 0x80 {
            return .rfc4122
        }
        // 110 = Microsoft
        if byte & 0xE0 == 0xC0 {
            return .microsoft
        }
        // 111 = Future
        return .future
    }
}
