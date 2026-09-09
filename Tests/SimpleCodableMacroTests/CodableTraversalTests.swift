//
//  CodableTraversalTests.swift
//  SimpleCodableMacroTests
//
//  Created by snow on 9/10/26.
//

import Foundation
import Testing
import SimpleCodableMacro

@Suite struct CodableTraversalTests {
    @Test("CodableTraversal Using") func CodableTraversalMacroTest() throws {
        let CodableByConstantJson = #"""
        {
            "role": "B",
            "name": "N"
        }
        """#
        let x = try JSONDecoder().decode(T.self, from: CodableByConstantJson.data(using: .utf8)!)
        print(x)
        let y = try JSONEncoder().encode(x)
        print(String(data: y, encoding: .utf8)!)
    }
}
