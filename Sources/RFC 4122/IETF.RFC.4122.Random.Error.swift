extension IETF.RFC.`4122`.Random {

    public enum Error: Swift::Error, Sendable {

        case platformFailure

        case unbound
    }
}
