// RFC_4122.Random.Error.swift
// Error type for the RFC 4122 random byte provider

extension RFC_4122.Random {
    /// Errors from the random byte provider.
    public enum Error: Swift.Error, Sendable {
        /// The platform random number generator failed.
        case platformFailure
    }
}
