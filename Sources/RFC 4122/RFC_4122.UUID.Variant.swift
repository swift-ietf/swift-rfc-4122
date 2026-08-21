extension RFC_4122.UUID {

    public enum Variant: Sendable, Hashable {

        case ncs

        case rfc4122

        case microsoft

        case future
    }

    public var variant: Variant {
        let byte = bytes.8

        if byte & 0x80 == 0 {
            return .ncs
        }

        if byte & 0xC0 == 0x80 {
            return .rfc4122
        }

        if byte & 0xE0 == 0xC0 {
            return .microsoft
        }

        return .future
    }
}
