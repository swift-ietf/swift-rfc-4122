// RFC_4122.UUID Tests.swift

import Testing
@testable import RFC_4122

extension RFC_4122.UUID {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct EdgeCase {}
        @Suite struct Integration {}
    }
}

// MARK: - Unit Tests

extension RFC_4122.UUID.Test.Unit {

    // MARK: Parsing

    @Test("Parses hyphenated lowercase UUID")
    func hyphenatedLowercase() throws {
        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        #expect(uuid.description == "550e8400-e29b-41d4-a716-446655440000")
    }

    @Test("Parses hyphenated uppercase UUID")
    func hyphenatedUppercase() throws {
        let uuid = try RFC_4122.UUID("550E8400-E29B-41D4-A716-446655440000")
        #expect(uuid.description == "550e8400-e29b-41d4-a716-446655440000")
    }

    @Test("Parses compact lowercase UUID")
    func compactLowercase() throws {
        let uuid = try RFC_4122.UUID("550e8400e29b41d4a716446655440000")
        #expect(uuid.description == "550e8400-e29b-41d4-a716-446655440000")
    }

    @Test("Parses compact uppercase UUID")
    func compactUppercase() throws {
        let uuid = try RFC_4122.UUID("550E8400E29B41D4A716446655440000")
        #expect(uuid.description == "550e8400-e29b-41d4-a716-446655440000")
    }

    // MARK: Byte Array

    @Test("Creates from byte array")
    func fromByteArray() throws {
        let bytes: [UInt8] = [
            0x55, 0x0e, 0x84, 0x00,
            0xe2, 0x9b, 0x41, 0xd4,
            0xa7, 0x16, 0x44, 0x66,
            0x55, 0x44, 0x00, 0x00
        ]
        let uuid = try RFC_4122.UUID(bytes)
        #expect(uuid.description == "550e8400-e29b-41d4-a716-446655440000")
    }

    @Test("Byte subscript access")
    func subscriptAccess() throws {
        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        #expect(uuid[0] == 0x55)
        #expect(uuid[1] == 0x0e)
        #expect(uuid[15] == 0x00)
    }

    // MARK: Version

    @Test("Detects version 1")
    func version1() throws {
        let uuid = try RFC_4122.UUID("6ba7b810-9dad-11d1-80b4-00c04fd430c8")
        #expect(uuid.version == .v1)
        #expect(uuid.versionNumber == 1)
    }

    @Test("Detects version 4")
    func version4() throws {
        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        #expect(uuid.version == .v4)
        #expect(uuid.versionNumber == 4)
    }

    @Test("Returns nil for unknown version")
    func unknownVersion() throws {
        let uuid = try RFC_4122.UUID("018f0b69-7c00-7000-8000-000000000000")
        #expect(uuid.version == nil)
        #expect(uuid.versionNumber == 7)
    }

    // MARK: Variant

    @Test("Detects RFC 4122 variant")
    func rfc4122Variant() throws {
        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        #expect(uuid.variant == .rfc4122)
    }

    @Test("Detects NCS variant")
    func ncsVariant() throws {
        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-0716-446655440000")
        #expect(uuid.variant == .ncs)
    }

    // MARK: String Formatting

    @Test("Compact format")
    func compactFormat() throws {
        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        #expect(uuid.string(.compact) == "550e8400e29b41d4a716446655440000")
    }

    @Test("Uppercase format")
    func uppercaseFormat() throws {
        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        #expect(uuid.string(.hyphenated, uppercase: true) == "550E8400-E29B-41D4-A716-446655440000")
    }

    // MARK: Equality

    @Test("Equal UUIDs from different formats")
    func equalFromDifferentFormats() throws {
        let uuid1 = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        let uuid2 = try RFC_4122.UUID("550E8400E29B41D4A716446655440000")
        #expect(uuid1 == uuid2)
    }

    @Test("Different UUIDs are not equal")
    func notEqual() throws {
        let uuid1 = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        let uuid2 = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440001")
        #expect(uuid1 != uuid2)
    }

    @Test("Hashable")
    func hashable() throws {
        let uuid1 = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        let uuid2 = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        var set: Set<RFC_4122.UUID> = []
        set.insert(uuid1)
        set.insert(uuid2)
        #expect(set.count == 1)
    }
}

// MARK: - RFC Test Vectors

extension RFC_4122.UUID.Test.Unit {

    // MARK: RFC 4122 Appendix C - Namespace UUIDs

    @Test("RFC 4122 Appendix C: DNS namespace UUID")
    func namespaceDNS() throws {
        // DNS namespace: 6ba7b810-9dad-11d1-80b4-00c04fd430c8
        let uuid = try RFC_4122.UUID("6ba7b810-9dad-11d1-80b4-00c04fd430c8")
        #expect(uuid.version == .v1)
        #expect(uuid.variant == .rfc4122)
        #expect(uuid[0] == 0x6b)
        #expect(uuid[1] == 0xa7)
        #expect(uuid[2] == 0xb8)
        #expect(uuid[3] == 0x10)
    }

    @Test("RFC 4122 Appendix C: URL namespace UUID")
    func namespaceURL() throws {
        // URL namespace: 6ba7b811-9dad-11d1-80b4-00c04fd430c8
        let uuid = try RFC_4122.UUID("6ba7b811-9dad-11d1-80b4-00c04fd430c8")
        #expect(uuid.version == .v1)
        #expect(uuid.variant == .rfc4122)
    }

    @Test("RFC 4122 Appendix C: OID namespace UUID")
    func namespaceOID() throws {
        // OID namespace: 6ba7b812-9dad-11d1-80b4-00c04fd430c8
        let uuid = try RFC_4122.UUID("6ba7b812-9dad-11d1-80b4-00c04fd430c8")
        #expect(uuid.version == .v1)
        #expect(uuid.variant == .rfc4122)
    }

    @Test("RFC 4122 Appendix C: X500 namespace UUID")
    func namespaceX500() throws {
        // X500 namespace: 6ba7b814-9dad-11d1-80b4-00c04fd430c8
        let uuid = try RFC_4122.UUID("6ba7b814-9dad-11d1-80b4-00c04fd430c8")
        #expect(uuid.version == .v1)
        #expect(uuid.variant == .rfc4122)
    }

    // MARK: Variant Bit Patterns

    @Test("Variant: Microsoft (110x pattern)")
    func microsoftVariant() throws {
        // Byte 8 = 0xC0 (110x xxxx) = Microsoft variant
        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-c716-446655440000")
        #expect(uuid.variant == .microsoft)
    }

    @Test("Variant: Future (111x pattern)")
    func futureVariant() throws {
        // Byte 8 = 0xE0 (111x xxxx) = Future variant
        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-e716-446655440000")
        #expect(uuid.variant == .future)
    }

    // MARK: All RFC 4122 Versions

    @Test("Version 2: DCE Security")
    func version2() throws {
        // Version 2 UUID (0x2 in version nibble)
        let uuid = try RFC_4122.UUID("000004d2-0000-2000-8000-00805f9b34fb")
        #expect(uuid.version == .v2)
        #expect(uuid.versionNumber == 2)
        #expect(uuid.variant == .rfc4122)
    }

    @Test("Version 3: MD5 name-based")
    func version3() throws {
        // v3 UUID for "www.example.com" in DNS namespace (known test vector)
        let uuid = try RFC_4122.UUID("5df41881-3aed-3515-88a7-2f4a814cf09e")
        #expect(uuid.version == .v3)
        #expect(uuid.versionNumber == 3)
        #expect(uuid.variant == .rfc4122)
    }

    @Test("Version 5: SHA-1 name-based")
    func version5() throws {
        // v5 UUID for "www.example.com" in DNS namespace (known test vector)
        let uuid = try RFC_4122.UUID("2ed6657d-e927-568b-95e1-2665a8aea6a2")
        #expect(uuid.version == .v5)
        #expect(uuid.versionNumber == 5)
        #expect(uuid.variant == .rfc4122)
    }
}

// MARK: - Edge Cases

extension RFC_4122.UUID.Test.EdgeCase {
    @Test("Rejects invalid length")
    func invalidLength() {
        #expect(throws: RFC_4122.UUID.Error.invalidLength) {
            try RFC_4122.UUID("550e8400")
        }
    }

    @Test("Rejects invalid character")
    func invalidCharacter() {
        #expect(throws: RFC_4122.UUID.Error.self) {
            try RFC_4122.UUID("550g8400-e29b-41d4-a716-446655440000")
        }
    }

    @Test("Rejects misplaced hyphens")
    func misplacedHyphens() {
        #expect(throws: RFC_4122.UUID.Error.invalidFormat) {
            try RFC_4122.UUID("550e-8400-e29b-41d4-a716446655440000")
        }
    }

    @Test("Rejects wrong length byte array")
    func wrongLengthByteArray() {
        #expect(throws: RFC_4122.UUID.Error.invalidLength) {
            try RFC_4122.UUID([0x55, 0x0e, 0x84])
        }
    }
}

// MARK: - Generation Tests

/// Mock hash provider with known test vectors for deterministic testing
private struct TestHashProvider: RFC_4122.HashProvider {
    // Known MD5 hash of DNS namespace + "www.example.com"
    // Result should produce UUID: 5df41881-3aed-3515-88a7-2f4a814cf09e
    func md5(_ data: [UInt8]) -> [UInt8] {
        // For testing, we use pre-computed hashes for known inputs
        // DNS namespace (16 bytes) + "www.example.com" (15 bytes) = 31 bytes
        if data.count == 31 && data[0] == 0x6b && data[16] == 0x77 {
            // This is DNS namespace + "www.example.com"
            // Pre-computed MD5: 5df41881-3aed-3515-88a7-2f4a814cf09e (before version/variant adjustment)
            // Raw MD5 hash that produces this UUID after version/variant bits are set:
            return [
                0x5d, 0xf4, 0x18, 0x81,
                0x3a, 0xed, 0x35, 0x15,  // byte 6 will have high nibble set to 0x3
                0x88, 0xa7, 0x2f, 0x4a,  // byte 8 will have high 2 bits set to 0x80
                0x81, 0x4c, 0xf0, 0x9e
            ]
        }
        // Default: return zeros (will still produce valid UUID structure)
        return [UInt8](repeating: 0, count: 16)
    }

    // Known SHA-1 hash of DNS namespace + "www.example.com"
    // Result should produce UUID: 2ed6657d-e927-568b-95e1-2665a8aea6a2
    func sha1(_ data: [UInt8]) -> [UInt8] {
        if data.count == 31 && data[0] == 0x6b && data[16] == 0x77 {
            // This is DNS namespace + "www.example.com"
            // Raw SHA-1 hash (20 bytes) that produces the expected UUID:
            return [
                0x2e, 0xd6, 0x65, 0x7d,
                0xe9, 0x27, 0x56, 0x8b,  // byte 6 will have high nibble set to 0x5
                0x95, 0xe1, 0x26, 0x65,  // byte 8 will have high 2 bits set to 0x80
                0xa8, 0xae, 0xa6, 0xa2,
                0x00, 0x00, 0x00, 0x00   // SHA-1 is 20 bytes, last 4 not used
            ]
        }
        return [UInt8](repeating: 0, count: 20)
    }
}

/// Mock random provider for v4 testing
private struct MockRandom: RFC_4122.RandomProvider {
    let pattern: UInt8

    func fill(_ buffer: UnsafeMutableRawBufferPointer) throws(Never) {
        for i in buffer.indices {
            buffer[i] = pattern
        }
    }
}

extension RFC_4122.UUID.Test.Unit {

    // MARK: Namespace UUIDs

    @Test("UUID.dns matches RFC 4122 Appendix C")
    func namespaceDNSConstant() {
        #expect(RFC_4122.UUID.dns.description == "6ba7b810-9dad-11d1-80b4-00c04fd430c8")
    }

    @Test("UUID.url matches RFC 4122 Appendix C")
    func namespaceURLConstant() {
        #expect(RFC_4122.UUID.url.description == "6ba7b811-9dad-11d1-80b4-00c04fd430c8")
    }

    @Test("UUID.oid matches RFC 4122 Appendix C")
    func namespaceOIDConstant() {
        #expect(RFC_4122.UUID.oid.description == "6ba7b812-9dad-11d1-80b4-00c04fd430c8")
    }

    @Test("UUID.x500 matches RFC 4122 Appendix C")
    func namespaceX500Constant() {
        #expect(RFC_4122.UUID.x500.description == "6ba7b814-9dad-11d1-80b4-00c04fd430c8")
    }

    // MARK: v3 Generation

    @Test("v3 generates correct version and variant")
    func v3VersionAndVariant() {
        let uuid = RFC_4122.UUID.v3(
            namespace: .dns,
            name: "test",
            using: TestHashProvider()
        )

        #expect(uuid.version == .v3)
        #expect(uuid.versionNumber == 3)
        #expect(uuid.variant == .rfc4122)
    }

    @Test("v3 is deterministic (same input = same output)")
    func v3Deterministic() {
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

    @Test("v3 known test vector: www.example.com in DNS namespace")
    func v3KnownVector() {
        let uuid = RFC_4122.UUID.v3(
            namespace: .dns,
            name: "www.example.com",
            using: TestHashProvider()
        )

        // Known result for DNS namespace + "www.example.com"
        #expect(uuid.description == "5df41881-3aed-3515-88a7-2f4a814cf09e")
    }

    @Test("v3 with bytes input")
    func v3WithBytes() {
        let nameBytes = Array("test".utf8)
        let uuid = RFC_4122.UUID.v3(
            namespace: .dns,
            nameBytes: nameBytes,
            using: TestHashProvider()
        )

        #expect(uuid.version == .v3)
        #expect(uuid.variant == .rfc4122)
    }

    // MARK: v5 Generation

    @Test("v5 generates correct version and variant")
    func v5VersionAndVariant() {
        let uuid = RFC_4122.UUID.v5(
            namespace: .dns,
            name: "test",
            using: TestHashProvider()
        )

        #expect(uuid.version == .v5)
        #expect(uuid.versionNumber == 5)
        #expect(uuid.variant == .rfc4122)
    }

    @Test("v5 is deterministic (same input = same output)")
    func v5Deterministic() {
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

    @Test("v5 known test vector: www.example.com in DNS namespace")
    func v5KnownVector() {
        let uuid = RFC_4122.UUID.v5(
            namespace: .dns,
            name: "www.example.com",
            using: TestHashProvider()
        )

        // Known result for DNS namespace + "www.example.com"
        #expect(uuid.description == "2ed6657d-e927-568b-95e1-2665a8aea6a2")
    }

    // MARK: v4 Generation

    @Test("v4 generates correct version and variant")
    func v4VersionAndVariant() {
        let uuid = RFC_4122.UUID.v4(using: MockRandom(pattern: 0xAA))

        #expect(uuid.version == .v4)
        #expect(uuid.versionNumber == 4)
        #expect(uuid.variant == .rfc4122)
    }

    @Test("v4 preserves random bits correctly")
    func v4RandomBits() {
        let uuid = RFC_4122.UUID.v4(using: MockRandom(pattern: 0xFF))

        // Byte 6: version 4 (0x40) | low nibble (0x0F) = 0x4F
        #expect(uuid[6] == 0x4F)

        // Byte 8: variant (0x80) | low 6 bits (0x3F) = 0xBF
        #expect(uuid[8] == 0xBF)

        // Other bytes should be 0xFF
        for i in [0, 1, 2, 3, 4, 5, 7, 9, 10, 11, 12, 13, 14, 15] {
            #expect(uuid[i] == 0xFF)
        }
    }

    @Test("v4 closure-based generation")
    func v4Closure() throws {
        let uuid = try RFC_4122.UUID.v4 { buffer in
            for i in buffer.indices {
                buffer[i] = 0x55
            }
        }

        #expect(uuid.version == .v4)
        #expect(uuid.variant == .rfc4122)
    }
}
