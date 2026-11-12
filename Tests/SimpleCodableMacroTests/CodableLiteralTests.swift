import Foundation
import Testing
import SimpleCodableMacro

@CodableLiteral
internal enum StringLiteralValue: String {
    case alpha = "A"
    case `func`
    case `A-A`
}

@Suite
struct CodableLiteralTests {
    @Test
    func decodesExplicitKeywordAndEscapedValues() throws {
        let explicit = try TestJSON.decode(StringLiteralValue.self, from: #""A""#)
        let keyword = try TestJSON.decode(StringLiteralValue.self, from: #""func""#)
        let escaped = try TestJSON.decode(StringLiteralValue.self, from: #""A-A""#)

        #expect(explicit == .alpha)
        #expect(keyword == .func)
        #expect(escaped == .`A-A`)
        #expect(try TestJSON.string(from: escaped) == #""A-A""#)
        print(explicit)
        print(keyword)
        print(escaped)
    }

    @Test
    func rejectsUnknownRawValues() {
        #expect(throws: (any Error).self) {
            try TestJSON.decode(StringLiteralValue.self, from: #""unknown""#)
        }
    }
}
