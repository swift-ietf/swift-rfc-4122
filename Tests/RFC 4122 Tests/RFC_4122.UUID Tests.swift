import Testing

@testable import RFC_4122

extension RFC_4122.UUID {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
    }
}

extension RFC_4122.UUID.Test.Unit {

    @Test
    func `Parses hyphenated lowercase UUID`() throws {
        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        #expect(uuid.description == "550e8400-e29b-41d4-a716-446655440000")
    }

    @Test
    func `Parses hyphenated uppercase UUID`() throws {
        let uuid = try RFC_4122.UUID("550E8400-E29B-41D4-A716-446655440000")
        #expect(uuid.description == "550e8400-e29b-41d4-a716-446655440000")
    }

    @Test
    func `Parses compact lowercase UUID`() throws {
        let uuid = try RFC_4122.UUID("550e8400e29b41d4a716446655440000")
        #expect(uuid.description == "550e8400-e29b-41d4-a716-446655440000")
    }

    @Test
    func `Parses compact uppercase UUID`() throws {
        let uuid = try RFC_4122.UUID("550E8400E29B41D4A716446655440000")
        #expect(uuid.description == "550e8400-e29b-41d4-a716-446655440000")
    }

    @Test
    func `Creates from byte array`() throws {
        let bytes: [UInt8] = [
            0x55, 0x0e, 0x84, 0x00,
            0xe2, 0x9b, 0x41, 0xd4,
            0xa7, 0x16, 0x44, 0x66,
            0x55, 0x44, 0x00, 0x00,
        ]
        let uuid = try RFC_4122.UUID(bytes)
        #expect(uuid.description == "550e8400-e29b-41d4-a716-446655440000")
    }

    @Test
    func `Byte subscript access`() throws {
        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        #expect(uuid[0] == 0x55)
        #expect(uuid[1] == 0x0e)
        #expect(uuid[15] == 0x00)
    }

    @Test
    func `Detects version 1`() throws {
        let uuid = try RFC_4122.UUID("6ba7b810-9dad-11d1-80b4-00c04fd430c8")
        #expect(uuid.version == .v1)
        #expect(uuid.versionNumber == 1)
    }

    @Test
    func `Detects version 4`() throws {
        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        #expect(uuid.version == .v4)
        #expect(uuid.versionNumber == 4)
    }

    @Test
    func `Returns nil for unknown version`() throws {
        let uuid = try RFC_4122.UUID("018f0b69-7c00-7000-8000-000000000000")
        #expect(uuid.version == nil)
        #expect(uuid.versionNumber == 7)
    }

    @Test
    func `Detects RFC 4122 variant`() throws {
        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        #expect(uuid.variant == .rfc4122)
    }

    @Test
    func `Detects NCS variant`() throws {
        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-0716-446655440000")
        #expect(uuid.variant == .ncs)
    }

    @Test
    func `Compact format`() throws {
        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        #expect(uuid.string(.compact) == "550e8400e29b41d4a716446655440000")
    }

    @Test
    func `Uppercase format`() throws {
        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        #expect(uuid.string(.hyphenated, uppercase: true) == "550E8400-E29B-41D4-A716-446655440000")
    }

    @Test
    func `Equal UUIDs from different formats`() throws {
        let uuid1 = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        let uuid2 = try RFC_4122.UUID("550E8400E29B41D4A716446655440000")
        #expect(uuid1 == uuid2)
    }

    @Test
    func `Different UUIDs are not equal`() throws {
        let uuid1 = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        let uuid2 = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440001")
        #expect(uuid1 != uuid2)
    }

    @Test
    func `Hashable`() throws {
        let uuid1 = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        let uuid2 = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        var set: Set<RFC_4122.UUID> = []
        set.insert(uuid1)
        set.insert(uuid2)
        #expect(set.count == 1)
    }
}

extension RFC_4122.UUID.Test.Unit {

    @Test
    func `RFC 4122 Appendix C: DNS namespace UUID`() throws {

        let uuid = try RFC_4122.UUID("6ba7b810-9dad-11d1-80b4-00c04fd430c8")
        #expect(uuid.version == .v1)
        #expect(uuid.variant == .rfc4122)
        #expect(uuid[0] == 0x6b)
        #expect(uuid[1] == 0xa7)
        #expect(uuid[2] == 0xb8)
        #expect(uuid[3] == 0x10)
    }

    @Test
    func `RFC 4122 Appendix C: URL namespace UUID`() throws {

        let uuid = try RFC_4122.UUID("6ba7b811-9dad-11d1-80b4-00c04fd430c8")
        #expect(uuid.version == .v1)
        #expect(uuid.variant == .rfc4122)
    }

    @Test
    func `RFC 4122 Appendix C: OID namespace UUID`() throws {

        let uuid = try RFC_4122.UUID("6ba7b812-9dad-11d1-80b4-00c04fd430c8")
        #expect(uuid.version == .v1)
        #expect(uuid.variant == .rfc4122)
    }

    @Test
    func `RFC 4122 Appendix C: X500 namespace UUID`() throws {

        let uuid = try RFC_4122.UUID("6ba7b814-9dad-11d1-80b4-00c04fd430c8")
        #expect(uuid.version == .v1)
        #expect(uuid.variant == .rfc4122)
    }

    @Test
    func `Variant: Microsoft (110x pattern)`() throws {

        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-c716-446655440000")
        #expect(uuid.variant == .microsoft)
    }

    @Test
    func `Variant: Future (111x pattern)`() throws {

        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-e716-446655440000")
        #expect(uuid.variant == .future)
    }

    @Test
    func `Version 2: DCE Security`() throws {

        let uuid = try RFC_4122.UUID("000004d2-0000-2000-8000-00805f9b34fb")
        #expect(uuid.version == .v2)
        #expect(uuid.versionNumber == 2)
        #expect(uuid.variant == .rfc4122)
    }

    @Test
    func `Version 3: MD5 name-based`() throws {

        let uuid = try RFC_4122.UUID("5df41881-3aed-3515-88a7-2f4a814cf09e")
        #expect(uuid.version == .v3)
        #expect(uuid.versionNumber == 3)
        #expect(uuid.variant == .rfc4122)
    }

    @Test
    func `Version 5: SHA-1 name-based`() throws {

        let uuid = try RFC_4122.UUID("2ed6657d-e927-568b-95e1-2665a8aea6a2")
        #expect(uuid.version == .v5)
        #expect(uuid.versionNumber == 5)
        #expect(uuid.variant == .rfc4122)
    }
}

extension RFC_4122.UUID.Test.`Edge Case` {
    @Test
    func `Rejects invalid length`() {
        #expect(throws: RFC_4122.UUID.Error.invalidLength) {
            try RFC_4122.UUID("550e8400")
        }
    }

    @Test
    func `Rejects invalid character`() {
        #expect(throws: RFC_4122.UUID.Error.self) {
            try RFC_4122.UUID("550g8400-e29b-41d4-a716-446655440000")
        }
    }

    @Test
    func `Rejects misplaced hyphens`() {
        #expect(throws: RFC_4122.UUID.Error.invalidFormat) {
            try RFC_4122.UUID("550e-8400-e29b-41d4-a716446655440000")
        }
    }

    @Test
    func `Rejects wrong length byte array`() {
        #expect(throws: RFC_4122.UUID.Error.invalidLength) {
            try RFC_4122.UUID([0x55, 0x0e, 0x84])
        }
    }
}

private struct TestHashProvider: RFC_4122.HashProvider {}

extension TestHashProvider {

    func md5(_ data: [UInt8]) -> [UInt8] {

        if data.count == 31 && data[0] == 0x6b && data[16] == 0x77 {

            return [
                0x5d, 0xf4, 0x18, 0x81,
                0x3a, 0xed, 0x35, 0x15,
                0x88, 0xa7, 0x2f, 0x4a,
                0x81, 0x4c, 0xf0, 0x9e,
            ]
        }

        return [UInt8](repeating: 0, count: 16)
    }

    func sha1(_ data: [UInt8]) -> [UInt8] {
        if data.count == 31 && data[0] == 0x6b && data[16] == 0x77 {

            return [
                0x2e, 0xd6, 0x65, 0x7d,
                0xe9, 0x27, 0x56, 0x8b,
                0x95, 0xe1, 0x26, 0x65,
                0xa8, 0xae, 0xa6, 0xa2,
                0x00, 0x00, 0x00, 0x00,
            ]
        }
        return [UInt8](repeating: 0, count: 20)
    }
}

private struct MockRandom: RFC_4122.RandomProvider {
    let pattern: UInt8
}

extension MockRandom {
    func fill(_ buffer: UnsafeMutableRawBufferPointer) throws(Never) {
        for i in buffer.indices {
            buffer[i] = pattern
        }
    }
}

extension RFC_4122.UUID.Test.Unit {

    @Test
    func `UUID.dns matches RFC 4122 Appendix C`() {
        #expect(RFC_4122.UUID.dns.description == "6ba7b810-9dad-11d1-80b4-00c04fd430c8")
    }

    @Test
    func `UUID.url matches RFC 4122 Appendix C`() {
        #expect(RFC_4122.UUID.url.description == "6ba7b811-9dad-11d1-80b4-00c04fd430c8")
    }

    @Test
    func `UUID.oid matches RFC 4122 Appendix C`() {
        #expect(RFC_4122.UUID.oid.description == "6ba7b812-9dad-11d1-80b4-00c04fd430c8")
    }

    @Test
    func `UUID.x500 matches RFC 4122 Appendix C`() {
        #expect(RFC_4122.UUID.x500.description == "6ba7b814-9dad-11d1-80b4-00c04fd430c8")
    }

    @Test
    func `v3 generates correct version and variant`() {
        let uuid = RFC_4122.UUID.v3(
            namespace: .dns,
            name: "test",
            using: TestHashProvider()
        )

        #expect(uuid.version == .v3)
        #expect(uuid.versionNumber == 3)
        #expect(uuid.variant == .rfc4122)
    }

    @Test
    func `v3 is deterministic (same input = same output)`() {
        let uuid1 = RFC_4122.UUID.v3(
            namespace: .dns,
            name: "www.example.com",
            using: TestHashProvider()
        )
        let uuid2 = RFC_4122.UUID.v3(
            namespace: .dns,
            name: "www.example.com",
            using: TestHashProvider()
        )

        #expect(uuid1 == uuid2)
    }

    @Test
    func `v3 known test vector: www.example.com in DNS namespace`() {
        let uuid = RFC_4122.UUID.v3(
            namespace: .dns,
            name: "www.example.com",
            using: TestHashProvider()
        )

        #expect(uuid.description == "5df41881-3aed-3515-88a7-2f4a814cf09e")
    }

    @Test
    func `v3 with bytes input`() {
        let nameBytes = Array("test".utf8)
        let uuid = RFC_4122.UUID.v3(
            namespace: .dns,
            nameBytes: nameBytes,
            using: TestHashProvider()
        )

        #expect(uuid.version == .v3)
        #expect(uuid.variant == .rfc4122)
    }

    @Test
    func `v5 generates correct version and variant`() {
        let uuid = RFC_4122.UUID.v5(
            namespace: .dns,
            name: "test",
            using: TestHashProvider()
        )

        #expect(uuid.version == .v5)
        #expect(uuid.versionNumber == 5)
        #expect(uuid.variant == .rfc4122)
    }

    @Test
    func `v5 is deterministic (same input = same output)`() {
        let uuid1 = RFC_4122.UUID.v5(
            namespace: .dns,
            name: "www.example.com",
            using: TestHashProvider()
        )
        let uuid2 = RFC_4122.UUID.v5(
            namespace: .dns,
            name: "www.example.com",
            using: TestHashProvider()
        )

        #expect(uuid1 == uuid2)
    }

    @Test
    func `v5 known test vector: www.example.com in DNS namespace`() {
        let uuid = RFC_4122.UUID.v5(
            namespace: .dns,
            name: "www.example.com",
            using: TestHashProvider()
        )

        #expect(uuid.description == "2ed6657d-e927-568b-95e1-2665a8aea6a2")
    }

    @Test
    func `v4 generates correct version and variant`() {
        let uuid = RFC_4122.UUID.v4(using: MockRandom(pattern: 0xAA))

        #expect(uuid.version == .v4)
        #expect(uuid.versionNumber == 4)
        #expect(uuid.variant == .rfc4122)
    }

    @Test
    func `v4 preserves random bits correctly`() {
        let uuid = RFC_4122.UUID.v4(using: MockRandom(pattern: 0xFF))

        #expect(uuid[6] == 0x4F)

        #expect(uuid[8] == 0xBF)

        for i in [0, 1, 2, 3, 4, 5, 7, 9, 10, 11, 12, 13, 14, 15] {
            #expect(uuid[i] == 0xFF)
        }
    }

    @Test
    func `v4 closure-based generation`() throws {
        let uuid = try RFC_4122.UUID.v4 { buffer in
            for i in buffer.indices {
                buffer[i] = 0x55
            }
        }

        #expect(uuid.version == .v4)
        #expect(uuid.variant == .rfc4122)
    }
}
