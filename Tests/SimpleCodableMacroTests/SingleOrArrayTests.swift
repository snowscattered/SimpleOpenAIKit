//
//  SingleOrArrayTests.swift
//  SimpleCodableMacroTests
//
//  Created by snow on 9/10/26.
//

import Foundation
import Testing
import SimpleCodableMacro

@Suite struct SingleOrArrayTests {
    @Test("SingleOrArray Using") func SingleOrArrayMacroTest() throws {
        do {
            let content = #"["ABC", "abc"]"#
            let input = try JSONDecoder().decode(Input.self ,from: content.data(using: .utf8)!)
            print(input)
        } catch { print(error) }
    }

    @Test("SingleOrArray Literal Conformances")
    func singleOrArrayLiteralConformances() {
        let single: Input = "ABC"
        if case .string(let value) = single {
            #expect(value == "ABC")
        } else {
            Issue.record("Expected .string")
        }

        let multiple: Input = [1, 2, 3]
        if case .array(let values) = multiple {
            #expect(values == [1, 2, 3])
        } else {
            Issue.record("Expected .array")
        }
    }

    @Test("SingleOrArray Skips NonLiteral Single Case")
    func singleOrArrayNonLiteralSingleCase() {
        let multiple: NonLiteralInput = [NonLiteralSingleValue(), NonLiteralSingleValue()]
        if case .array(let values) = multiple {
            #expect(values.count == 2)
        } else {
            Issue.record("Expected .array")
        }
    }
}
