import Dependency_Primitives

extension RFC_4122.UUID {

    public static func v3(namespace: Self, name: String) -> Self {
        v3(namespace: namespace, name: name, using: Dependency.Scope.current[RFC_4122.Hash.self])
    }

    public static func v3(namespace: Self, nameBytes: [UInt8]) -> Self {
        v3(
            namespace: namespace,
            nameBytes: nameBytes,
            using: Dependency.Scope.current[RFC_4122.Hash.self]
        )
    }
}

extension RFC_4122.UUID {

    public static func v5(namespace: Self, name: String) -> Self {
        v5(namespace: namespace, name: name, using: Dependency.Scope.current[RFC_4122.Hash.self])
    }

    public static func v5(namespace: Self, nameBytes: [UInt8]) -> Self {
        v5(
            namespace: namespace,
            nameBytes: nameBytes,
            using: Dependency.Scope.current[RFC_4122.Hash.self]
        )
    }
}

extension RFC_4122.UUID {

    public static func v4() throws(RFC_4122.Random.Error) -> Self {
        try v4(using: Dependency.Scope.current[RFC_4122.Random.self])
    }
}
