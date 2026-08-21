extension RFC_4122 {

    public protocol HashProvider: Sendable {

        func md5(_ data: [UInt8]) -> [UInt8]

        func sha1(_ data: [UInt8]) -> [UInt8]
    }
}
