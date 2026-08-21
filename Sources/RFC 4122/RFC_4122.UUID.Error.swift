extension RFC_4122.UUID {

    public enum Error: Swift.Error, Sendable, Hashable {

        case invalidLength

        case invalidCharacter(Character, at: Int)

        case invalidFormat
    }
}
