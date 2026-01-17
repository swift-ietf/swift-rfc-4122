// String+RFC_4122.swift
// String representation and formatting for UUIDs

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
    /// - Parameters:
    ///   - format: The output format (hyphenated or compact).
    ///   - uppercase: Whether to use uppercase hex digits (default: false).
    /// - Returns: The formatted UUID string.
    public func string(_ format: Format, uppercase: Bool = false) -> String {
        let hexChars: [Character] = uppercase
            ? ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
            : ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]

        var result: [Character] = []
        let capacity = format == .hyphenated ? 36 : 32
        result.reserveCapacity(capacity)

        for (index, byte) in byteArray.enumerated() {
            // Add hyphen at appropriate positions for hyphenated format
            if format == .hyphenated {
                switch index {
                case 4, 6, 8, 10:
                    result.append("-")
                default:
                    break
                }
            }

            // Convert byte to two hex characters
            let highNibble = Int(byte >> 4)
            let lowNibble = Int(byte & 0x0F)
            result.append(hexChars[highNibble])
            result.append(hexChars[lowNibble])
        }

        return String(result)
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
