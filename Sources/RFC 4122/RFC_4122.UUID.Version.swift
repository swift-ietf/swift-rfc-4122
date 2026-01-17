// RFC_4122.UUID.Version.swift
// UUID version field per RFC 4122 Section 4.1.3

extension RFC_4122.UUID {
    /// The UUID version as defined in RFC 4122 Section 4.1.3.
    ///
    /// The version number is in the most significant 4 bits of byte 6
    /// (the time_hi_and_version field).
    ///
    /// - Note: RFC 9562 adds versions 6, 7, and 8. Use `RFC_9562.UUID.Version`
    ///   for the complete set of versions.
    public enum Version: UInt8, Sendable, Hashable {
        /// Time-based version (uses MAC address and timestamp).
        case v1 = 1

        /// DCE Security version (with POSIX UIDs).
        case v2 = 2

        /// Name-based version using MD5 hashing.
        case v3 = 3

        /// Randomly or pseudo-randomly generated version.
        case v4 = 4

        /// Name-based version using SHA-1 hashing.
        case v5 = 5
    }

    /// The version of this UUID, if it is a recognized RFC 4122 version.
    ///
    /// Returns `nil` if the version bits contain a value not defined in RFC 4122
    /// (e.g., versions 6-8 from RFC 9562, or invalid values).
    ///
    /// The version is extracted from the high 4 bits of byte 6.
    public var version: Version? {
        let versionNibble = bytes.6 >> 4
        return Version(rawValue: versionNibble)
    }

    /// The raw version number from byte 6.
    ///
    /// Unlike `version`, this returns the raw value regardless of whether
    /// it's a recognized RFC 4122 version. Use this to detect RFC 9562
    /// versions or other non-standard values.
    public var versionNumber: UInt8 {
        bytes.6 >> 4
    }
}
