// RFC_4122.UUID Foundation Comparison Tests.swift
// Performance comparison between RFC_4122.UUID and Foundation.UUID

import Testing
import Time_Primitives
import Format_Primitives
import Foundation
@testable import RFC_4122

// Disambiguate from Foundation.Measurement
private typealias PerfMeasurement = Benchmark.Measurement

// MARK: - Foundation Comparison Suite

extension RFC_4122.UUID.Test {
    @Suite("Foundation Comparison", .serialized)
    struct FoundationComparison {}
}

// MARK: - Parsing Comparison

extension RFC_4122.UUID.Test.FoundationComparison {

    @Test
    func `Parse: RFC_4122.UUID vs Foundation.UUID`() {
        let input = "550e8400-e29b-41d4-a716-446655440000"

        let rfc4122 = Benchmark.measure(iterations: 1000, warmup: 100, name: "RFC_4122.UUID parsing") {
            _ = try? RFC_4122.UUID(input)
        }

        let foundation = Benchmark.measure(iterations: 1000, warmup: 100, name: "Foundation.UUID parsing") {
            _ = Foundation.UUID(uuidString: input)
        }

        printComparison("Parsing", rfc4122: rfc4122, foundation: foundation)
    }

    @Test
    func `Parse batch: RFC_4122.UUID vs Foundation.UUID (1000 UUIDs)`() {
        let input = "550e8400-e29b-41d4-a716-446655440000"

        let rfc4122 = Benchmark.measure(iterations: 10, warmup: 2, name: "RFC_4122 parse x1000") {
            for _ in 0..<1000 {
                _ = try? RFC_4122.UUID(input)
            }
        }

        let foundation = Benchmark.measure(iterations: 10, warmup: 2, name: "Foundation parse x1000") {
            for _ in 0..<1000 {
                _ = Foundation.UUID(uuidString: input)
            }
        }

        printComparison("Batch Parsing (1000 UUIDs)", rfc4122: rfc4122, foundation: foundation)
    }
}

// MARK: - Formatting Comparison

extension RFC_4122.UUID.Test.FoundationComparison {

    @Test
    func `Format: RFC_4122.UUID vs Foundation.UUID`() throws {
        let rfc4122UUID = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        let foundationUUID = Foundation.UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!

        let rfc4122 = Benchmark.measure(iterations: 1000, warmup: 100, name: "RFC_4122.UUID formatting") {
            _ = rfc4122UUID.description
        }

        let foundation = Benchmark.measure(iterations: 1000, warmup: 100, name: "Foundation.UUID formatting") {
            _ = foundationUUID.uuidString
        }

        printComparison("Formatting", rfc4122: rfc4122, foundation: foundation)
    }

    @Test
    func `Format lowercase: RFC_4122.UUID vs Foundation.UUID`() throws {
        let rfc4122UUID = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        let foundationUUID = Foundation.UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!

        let rfc4122 = Benchmark.measure(iterations: 1000, warmup: 100, name: "RFC_4122 lowercase") {
            _ = rfc4122UUID.description
        }

        let foundation = Benchmark.measure(iterations: 1000, warmup: 100, name: "Foundation lowercased") {
            _ = foundationUUID.uuidString.lowercased()
        }

        printComparison("Lowercase Formatting", rfc4122: rfc4122, foundation: foundation,
                       note: "RFC_4122 native lowercase vs Foundation + .lowercased()")
    }
}

// MARK: - Random Generation Comparison

extension RFC_4122.UUID.Test.FoundationComparison {

    @Test
    func `Random generation: RFC_4122.UUID vs Foundation.UUID`() {
        let rfc4122 = Benchmark.measure(iterations: 1000, warmup: 100, name: "RFC_4122.UUID.v4") {
            _ = try? RFC_4122.UUID.v4(using: SystemRandom())
        }

        let foundation = Benchmark.measure(iterations: 1000, warmup: 100, name: "Foundation.UUID()") {
            _ = Foundation.UUID()
        }

        printComparison("Random Generation", rfc4122: rfc4122, foundation: foundation)
    }

    @Test
    func `Random generation batch: 1000 UUIDs`() {
        let random = SystemRandom()

        let rfc4122 = Benchmark.measure(iterations: 10, warmup: 2, name: "RFC_4122 v4 x1000") {
            for _ in 0..<1000 {
                _ = try? RFC_4122.UUID.v4(using: random)
            }
        }

        let foundation = Benchmark.measure(iterations: 10, warmup: 2, name: "Foundation x1000") {
            for _ in 0..<1000 {
                _ = Foundation.UUID()
            }
        }

        printComparison("Batch Random Generation (1000 UUIDs)", rfc4122: rfc4122, foundation: foundation)
    }
}

// MARK: - Equality Comparison

extension RFC_4122.UUID.Test.FoundationComparison {

    @Test
    func `Equality: RFC_4122.UUID vs Foundation.UUID`() throws {
        let rfc1 = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        let rfc2 = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        let found1 = Foundation.UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!
        let found2 = Foundation.UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!

        let rfc4122 = Benchmark.measure(iterations: 1000, warmup: 100, name: "RFC_4122 equality") {
            _ = rfc1 == rfc2
        }

        let foundation = Benchmark.measure(iterations: 1000, warmup: 100, name: "Foundation equality") {
            _ = found1 == found2
        }

        printComparison("Equality", rfc4122: rfc4122, foundation: foundation)
    }

    @Test
    func `Hashing: RFC_4122.UUID vs Foundation.UUID`() throws {
        let rfc = try RFC_4122.UUID("550e8400-e29b-41d4-a716-446655440000")
        let found = Foundation.UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!

        let rfc4122 = Benchmark.measure(iterations: 1000, warmup: 100, name: "RFC_4122 hash") {
            _ = rfc.hashValue
        }

        let foundation = Benchmark.measure(iterations: 1000, warmup: 100, name: "Foundation hash") {
            _ = found.hashValue
        }

        printComparison("Hashing", rfc4122: rfc4122, foundation: foundation)
    }
}

// MARK: - Memory Layout Comparison

extension RFC_4122.UUID.Test.FoundationComparison {

    @Test
    func `Memory layout comparison`() {
        let rfc4122Size = MemoryLayout<RFC_4122.UUID>.size
        let rfc4122Stride = MemoryLayout<RFC_4122.UUID>.stride
        let rfc4122Alignment = MemoryLayout<RFC_4122.UUID>.alignment

        let foundationSize = MemoryLayout<Foundation.UUID>.size
        let foundationStride = MemoryLayout<Foundation.UUID>.stride
        let foundationAlignment = MemoryLayout<Foundation.UUID>.alignment

        print("""

            📊 Memory Layout:
               RFC_4122.UUID:   size=\(rfc4122Size) stride=\(rfc4122Stride) align=\(rfc4122Alignment)
               Foundation.UUID: size=\(foundationSize) stride=\(foundationStride) align=\(foundationAlignment)
               Equal: \(rfc4122Size == foundationSize && rfc4122Stride == foundationStride)
            """)

        #expect(rfc4122Size == 16, "RFC_4122.UUID should be exactly 16 bytes")
        #expect(foundationSize == 16, "Foundation.UUID should be exactly 16 bytes")
    }
}

// MARK: - System Random Provider

private struct SystemRandom: RFC_4122.RandomProvider {
    func fill(_ buffer: UnsafeMutableRawBufferPointer) throws(Never) {
        arc4random_buf(buffer.baseAddress!, buffer.count)
    }
}

// MARK: - Comparison Output

private func printComparison(
    _ label: String,
    rfc4122: PerfMeasurement,
    foundation: PerfMeasurement,
    note: String? = nil
) {
    let rfc = rfc4122.median.formatted(.duration)
    let found = foundation.median.formatted(.duration)
    let ratioStr = ratioString(rfc4122.median, foundation.median)

    var output = """

        📊 \(label):
           RFC_4122.UUID:   \(rfc) median
           Foundation.UUID: \(found) median
           Ratio:           \(ratioStr)
        """

    if let note = note {
        output += "\n       Note: \(note)"
    }

    print(output)
}

private func ratioString(_ a: Duration, _ b: Duration) -> String {
    let aNs = Double(a.components.attoseconds)
    let bNs = Double(b.components.attoseconds)
    guard bNs > 0 else { return "N/A" }
    let r = aNs / bNs
    if r < 1 {
        return (1 / r).formatted(.number.precision(2)) + "x faster"
    } else if r > 1 {
        return r.formatted(.number.precision(2)) + "x slower"
    } else {
        return "equal"
    }
}
