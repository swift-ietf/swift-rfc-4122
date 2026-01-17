// RFC_4122.UUID.Error.swift
// Parsing errors for UUID strings

extension RFC_4122.UUID {
    /// Errors that can occur when parsing a UUID string or byte array.
    public enum Error: Swift.Error, Sendable, Hashable {
        /// The input has an invalid length.
        ///
        /// UUID strings must be either 32 characters (compact) or 36 characters (hyphenated).
        /// Byte arrays must contain exactly 16 bytes.
        case invalidLength

        /// An invalid character was encountered at the specified position.
        ///
        /// UUID strings must contain only hexadecimal digits (0-9, a-f, A-F) and hyphens.
        case invalidCharacter(Character, at: Int)

        /// The UUID string format is invalid.
        ///
        /// For hyphenated format, hyphens must appear at positions 8, 13, 18, and 23.
        case invalidFormat
    }
}
