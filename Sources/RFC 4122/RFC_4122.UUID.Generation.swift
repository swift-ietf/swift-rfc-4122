extension RFC_4122.UUID {

    public static let dns = Self(
        bytes: (
            0x6b, 0xa7, 0xb8, 0x10,
            0x9d, 0xad, 0x11, 0xd1,
            0x80, 0xb4, 0x00, 0xc0,
            0x4f, 0xd4, 0x30, 0xc8
        )
    )

    public static let url = Self(
        bytes: (
            0x6b, 0xa7, 0xb8, 0x11,
            0x9d, 0xad, 0x11, 0xd1,
            0x80, 0xb4, 0x00, 0xc0,
            0x4f, 0xd4, 0x30, 0xc8
        )
    )

    public static let oid = Self(
        bytes: (
            0x6b, 0xa7, 0xb8, 0x12,
            0x9d, 0xad, 0x11, 0xd1,
            0x80, 0xb4, 0x00, 0xc0,
            0x4f, 0xd4, 0x30, 0xc8
        )
    )

    public static let x500 = Self(
        bytes: (
            0x6b, 0xa7, 0xb8, 0x14,
            0x9d, 0xad, 0x11, 0xd1,
            0x80, 0xb4, 0x00, 0xc0,
            0x4f, 0xd4, 0x30, 0xc8
        )
    )
}

extension RFC_4122.UUID {

    public static func v3<H: RFC_4122.HashProvider>(
        namespace: Self,
        name: String,
        using hashProvider: H
    ) -> Self {
        v3(namespace: namespace, nameBytes: Array(name.utf8), using: hashProvider)
    }

    public static func v3<H: RFC_4122.HashProvider>(
        namespace: Self,
        nameBytes: [UInt8],
        using hashProvider: H
    ) -> Self {

        var data = namespace.byteArray
        data.append(contentsOf: nameBytes)

        let hash = hashProvider.md5(data)
        precondition(hash.count == 16, "MD5 hash must be 16 bytes")

        var bytes = (
            hash[0], hash[1], hash[2], hash[3],
            hash[4], hash[5], hash[6], hash[7],
            hash[8], hash[9], hash[10], hash[11],
            hash[12], hash[13], hash[14], hash[15]
        )

        bytes.6 = (bytes.6 & 0x0F) | 0x30

        bytes.8 = (bytes.8 & 0x3F) | 0x80

        return Self(bytes: bytes)
    }
}

extension RFC_4122.UUID {

    public static func v5<H: RFC_4122.HashProvider>(
        namespace: Self,
        name: String,
        using hashProvider: H
    ) -> Self {
        v5(namespace: namespace, nameBytes: Array(name.utf8), using: hashProvider)
    }

    public static func v5<H: RFC_4122.HashProvider>(
        namespace: Self,
        nameBytes: [UInt8],
        using hashProvider: H
    ) -> Self {

        var data = namespace.byteArray
        data.append(contentsOf: nameBytes)

        let hash = hashProvider.sha1(data)
        precondition(hash.count == 20, "SHA-1 hash must be 20 bytes")

        var bytes = (
            hash[0], hash[1], hash[2], hash[3],
            hash[4], hash[5], hash[6], hash[7],
            hash[8], hash[9], hash[10], hash[11],
            hash[12], hash[13], hash[14], hash[15]
        )

        bytes.6 = (bytes.6 & 0x0F) | 0x50

        bytes.8 = (bytes.8 & 0x3F) | 0x80

        return Self(bytes: bytes)
    }
}

extension RFC_4122.UUID {

    public static func v4<R: RFC_4122.RandomProvider>(
        using random: R
    ) throws(R.RandomError) -> Self {
        var bytes:
            (
                UInt8, UInt8, UInt8, UInt8,
                UInt8, UInt8, UInt8, UInt8,
                UInt8, UInt8, UInt8, UInt8,
                UInt8, UInt8, UInt8, UInt8
            ) = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

        let outcome: Result<Void, R.RandomError> = Swift.withUnsafeMutableBytes(of: &bytes) {
            buffer in
            do throws(R.RandomError) {
                try unsafe random.fill(buffer)
                return .success(())
            } catch {
                return .failure(error)
            }
        }
        try outcome.get()

        bytes.6 = (bytes.6 & 0x0F) | 0x40

        bytes.8 = (bytes.8 & 0x3F) | 0x80

        return Self(bytes: bytes)
    }

    public static func v4<E: Swift.Error>(
        fillRandom: (UnsafeMutableRawBufferPointer) throws(E) -> Void
    ) throws(E) -> Self {
        var bytes:
            (
                UInt8, UInt8, UInt8, UInt8,
                UInt8, UInt8, UInt8, UInt8,
                UInt8, UInt8, UInt8, UInt8,
                UInt8, UInt8, UInt8, UInt8
            ) = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

        let outcome: Result<Void, E> = Swift.withUnsafeMutableBytes(of: &bytes) { buffer in
            do throws(E) {
                try unsafe fillRandom(buffer)
                return .success(())
            } catch {
                return .failure(error)
            }
        }
        try outcome.get()

        bytes.6 = (bytes.6 & 0x0F) | 0x40

        bytes.8 = (bytes.8 & 0x3F) | 0x80

        return Self(bytes: bytes)
    }
}
