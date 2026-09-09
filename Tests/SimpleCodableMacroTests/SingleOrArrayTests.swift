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
}
