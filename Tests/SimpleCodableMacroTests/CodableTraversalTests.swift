import Foundation
import Testing
import SimpleCodableMacro

@CodableTraversal
enum TraversalValue {
    case integer(Int)
    case text(String)
}

@Suite
struct CodableTraversalTests {
    @Test
    func decodingTriesCasesInDeclarationOrder() throws {
        let integer = try TestJSON.decode(TraversalValue.self, from: "3")
        let text = try TestJSON.decode(TraversalValue.self, from: #""hello""#)

        #expect(integer == .integer(3))
        #expect(text == .text("hello"))
        print(integer)
        print(text)
    }

    @Test
    func encodingDelegatesToTheSelectedPayload() throws {
        let integer = try TestJSON.string(from: TraversalValue.integer(4))
        let text = try TestJSON.string(from: TraversalValue.text("world"))

        #expect(integer == "4")
        #expect(text == #""world""#)
        print(integer)
        print(text)
    }

    @Test
    func decodingThrowsWhenNoPayloadMatches() {
        #expect(throws: (any Error).self) {
            try TestJSON.decode(TraversalValue.self, from: #"{"unknown":7}"#)
        }
    }
}
