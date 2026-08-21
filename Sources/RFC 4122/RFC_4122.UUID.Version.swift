extension RFC_4122.UUID {

    public enum Version: UInt8, Sendable, Hashable {

        case v1 = 1

        case v2 = 2

        case v3 = 3

        case v4 = 4

        case v5 = 5
    }

    public var version: Version? {
        let versionNibble = bytes.6 >> 4
        return Version(rawValue: versionNibble)
    }

    public var versionNumber: UInt8 {
        bytes.6 >> 4
    }
}
