//
//  BaseModelTests.swift
//  SimpleCodableMacroTests
//
//  Created by snow on 9/10/26.
//

import Foundation
import Testing
import SimpleCodableMacro

@Suite struct BaseModelTests {
    @Test("BaseModelNoWithExtra Using") func BaseModelNoWithExtraMacroTest() throws {
        let JSON = #"""
            {
                "A": 1,
                "B": 2,
                "C": [3, 4],
            }
        """#
        print("@BaseModelNoWithExtra Using")
        let fastRes = try JSONDecoder().decode(Fast.self, from: JSON.data(using: .utf8)!)
        print(fastRes)
        print(try fastRes.json())
    }

    @Test("BaseModelWithExtra Using") func BaseModelWithExtraMacroTest() throws {
        let JSON = #"""
            {
                "A": 1,
                "B": 2,
                "C": [3, 4],
            }
        """#
        let extraRes = try JSONDecoder().decode(Extra.self, from: JSON.data(using: .utf8)!)
        print(extraRes)
        print(try extraRes.json())
    }

    @Test("BaseModelWithExtra After Using") func BaseModelWithExtraAfterMacroTest() throws {
        let JSON = #"""
            {
                "A": 1,
                "B": 2,
                "C": [3, 4],
            }
        """#
        print("@BaseModelWithExtra after Using")
        let afterRes = try JSONDecoder().decode(After.self, from: JSON.data(using: .utf8)!)
        print(afterRes)
    }
    
    @Test("OptionModel Using") func OptionModelMacroTest() throws {
        // No key: the declared default is restored.
        let missing = try JSONDecoder().decode(OptionModel.self, from: Data("{}".utf8))
        print(missing)
        #expect(missing.d == 0)

        // Key present: the JSON value wins.
        let present = try JSONDecoder().decode(OptionModel.self, from: Data(#"{"d":7}"#.utf8))
        print(present)
        #expect(present.d == 7)

        // Explicit null: still nil.
        let null = try JSONDecoder().decode(OptionModel.self, from: Data(#"{"d":null}"#.utf8))
        print(null)
        #expect(null.d == nil)

        // Encoding is unchanged: nil is dropped, a value is written back.
        #expect(try null.json().contains("\"d\"") == false)
        #expect(try present.json().contains("\"d\" : 7") == true)
    }
}
