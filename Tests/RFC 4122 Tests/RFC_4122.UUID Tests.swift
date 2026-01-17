// RFC_4122.UUID Tests.swift

import Testing
import Testing_Extras
@testable import RFC_4122

extension RFC_4122.UUID {
    #TestSuites
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

// MARK: - Performance

extension RFC_4122.UUID.Test.Performance {
    @Test("UUID parsing", .timed(iterations: 100, warmup: 10))
    func parsing() throws {
        _ = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
    }

    @Test("UUID string conversion", .timed(iterations: 100, warmup: 10))
    func stringConversion() throws {
        let uuid = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        _ = uuid.description
    }
}
