import Testing

@testable import RFC_4122

enum `IETF.RFC.4122.UUID Invalid Character Tests` {}

extension `IETF.RFC.4122.UUID Invalid Character Tests` {
    @Suite
    struct `UUID invalid character` {
        @Test
        func `an ASCII non-hex character is reported with its position`() {
            #expect(throws: IETF.RFC.`4122`.UUID.Error.invalidCharacter("g", at: 5)) {
                try IETF.RFC.`4122`.UUID("01234g6789abcdef0123456789abcdef")
            }
        }

        @Test
        func `a combining mark after thirty compact digits is refused instead of trapping`() {
            #expect(throws: IETF.RFC.`4122`.UUID.Error.self) {
                try IETF.RFC.`4122`.UUID(String(repeating: "a", count: 30) + "\u{301}")
            }
        }

        @Test
        func `a combining mark ending a hyphenated form is refused instead of trapping`() {
            #expect(throws: IETF.RFC.`4122`.UUID.Error.self) {
                try IETF.RFC.`4122`.UUID("00000000-0000-0000-0000-0000000000\u{301}")
            }
        }

        @Test
        func `a multibyte character inside the digits is refused`() {
            #expect(throws: IETF.RFC.`4122`.UUID.Error.self) {
                try IETF.RFC.`4122`.UUID("é" + String(repeating: "a", count: 30))
            }
        }
    }
}
