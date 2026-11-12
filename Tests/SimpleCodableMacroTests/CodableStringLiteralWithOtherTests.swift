import Foundation
import Testing
import SimpleCodableMacro

@CodableStringLiteralWithOther
enum StringWithOtherValue {
    case alpha
    case beta
    case `a-b`
    case other(String)
}

@Suite
struct CodableStringLiteralWithOtherTests {
    @Test
    func stringLiteralsAlwaysUseTheOtherCase() {
        let known: StringWithOtherValue = "alpha"
        let unknown: StringWithOtherValue = "future"

        #expect(known == .other("alpha"))
        #expect(unknown == .other("future"))
        print(known)
        print(unknown)
    }

    @Test
    func decodingMapsKnownAndUnknownStrings() throws {
        let known = try TestJSON.decode(StringWithOtherValue.self, from: #""a-b""#)
        let unknown = try TestJSON.decode(StringWithOtherValue.self, from: #""future""#)

        #expect(known == .`a-b`)
        #expect(unknown == .other("future"))
        print(known)
        print(unknown)
    }

    @Test
    func encodingPreservesKnownAndOtherRawValues() throws {
        let known = try TestJSON.string(from: StringWithOtherValue.alpha)
        let other = try TestJSON.string(from: StringWithOtherValue.other("future"))

        #expect(known == #""alpha""#)
        #expect(other == #""future""#)
        #expect(StringWithOtherValue.alpha.rawValue == "alpha")
        #expect(StringWithOtherValue.other("future").rawValue == "future")
        print(known)
        print(other)
    }
}
