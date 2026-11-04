# swift-rfc-4122

Use this package when you parse, format or compare RFC 4122 UUIDs, or generate version 3, 4 or 5 UUIDs with a hash function or random source you provide. Start from `RFC_4122.UUID`. To generate UUIDs from the system's random source without wiring anything, or to use versions 6 to 8, use swift-uuids, which combines this package with swift-rfc-9562.

## Laws

- Parsing accepts exactly two forms: 36 characters with hyphens after the 8th, 12th, 16th and 20th digit, or 32 digits with no hyphens. Digits may be in either case. Any other length or layout is refused, and a bad character is reported with its UTF-8 byte offset.
- A UUID prints as lowercase hyphenated text unless you ask for compact or uppercase.
- A version 3 UUID is built from the MD5 hash, and a version 5 UUID from the first 16 bytes of the SHA-1 hash, of the namespace's 16 bytes followed by the name's bytes, which are UTF-8 for a string name. The same namespace and name always give the same UUID.
- Every generated UUID has its version in the top four bits of byte 6 and the RFC 4122 variant, bits 10, in the top two bits of byte 8. All other bits of a version 4 UUID come unchanged from the random source.
- `RFC_4122.UUID.variant` reads the top bits of byte 8: 0 is NCS, 10 is RFC 4122, 110 is Microsoft and 111 is reserved for the future. `RFC_4122.UUID.version` is nil for any version number other than 1 to 5; read `RFC_4122.UUID.versionNumber` for those.
- The test values of `RFC_4122.Random` and `RFC_4122.Hash` are deterministic stand-ins. The random source fills each byte with its own index, and each hash returns its input cut or zero-padded to 16 or 20 bytes.
