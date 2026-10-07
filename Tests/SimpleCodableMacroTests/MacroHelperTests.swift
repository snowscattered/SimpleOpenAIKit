//
//  MacroHelperTests.swift
//  SimpleCodableMacroTests
//

import Foundation
import Testing
import SimpleCodableMacro

@Suite struct MacroHelperTests {
    @Test("Macro helper regressions") func macroHelperRegressionsTest() throws {
        let multi = try JSONDecoder().decode(
            MultiBindingModel.self,
            from: Data(#"{"first":1,"second":"two"}"#.utf8)
        )
        #expect(multi.first == 1)
        #expect(multi.second == "two")

        let escaped = try JSONDecoder().decode(
            EscapedPropertyModel.self,
            from: Data(#"{"legacy-default":"value"}"#.utf8)
        )
        #expect(escaped.`default` == "value")
        #expect(try escaped.json().contains(#""default""#))

        let transient = try JSONDecoder().decode(
            Fast.self,
            from: Data(#"{"A":1,"B":2}"#.utf8)
        )
        #expect(transient.B == 2)
        #expect(!(try transient.json().contains(#""B""#)))

        let constant = try JSONDecoder().decode(
            Multi.self,
            from: Data(#"{"role":"E"}"#.utf8)
        )
        var role: String?
        if case .singleValue(let value) = constant {
            role = value.role
        }
        #expect(role == "E")
    }
}
