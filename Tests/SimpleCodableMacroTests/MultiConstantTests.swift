//
//  MultiConstantTests.swift
//  SimpleCodableMacroTests
//
//  Created by snow on 9/10/26.
//

import Foundation
import Testing
import SimpleCodableMacro

@Suite struct MultiConstantTests {
    @Test("MultiConstant Using") func MultiConstantMacroTest() throws {
        do {
            for role in ["D", "C"] {
                let json = #"{"role":"\#(role)"}"#
                let multi = try JSONDecoder().decode(Multi.self, from: json.data(using: .utf8)!)
                print(multi)
            }

            let aJSON = #"{"role":"A","name":"N"}"#
            let aMulti = try JSONDecoder().decode(Multi.self, from: aJSON.data(using: .utf8)!)
            print(aMulti)

            let singleValueJSON = #"{"role":"E"}"#
            let singleValue = try JSONDecoder().decode(Multi.self, from: singleValueJSON.data(using: .utf8)!)
            print(singleValue)
        } catch { print(error) }
    }
}
