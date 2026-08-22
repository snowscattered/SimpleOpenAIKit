//
//  SimpleCodableMacroTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/8/26.
//

import Foundation
import Testing
@testable import SimpleCodableMacro

@CodableLiteral
enum Literal: Int {
    case oneHundred = 100
    case twoHundred = 210
}
@SingleOrArray
enum Input {
    case string(String)
    case array([Int])
}
@BaseModelNoWithExtra
struct A {
    static let role: String = "A"
    let name: String
}
@BaseModelNoWithExtra
struct B {
    static let role: String = "B"
    let age: Int
}
@BaseModelNoWithExtra
struct C {
    static let role: String = "C"
    let score: Double
}
@BaseModelWithExtra
struct Other: Codable {
    var role: String
}

@CodableByConstant(field: "role", defaultCase: "other")
enum X {
    case a(A)
    case b(B)
    case c(C)
    case other(Other)
}
@CodableTraversal
enum T {
    case a(A)
    case b(B)
    case c(C)
    case other(Other)
}
@BaseModelNoWithExtra
struct Fast {
    let A: Int
    @transient let B: Int
}
@BaseModelWithExtra
struct Extra {
    let A: Int
}
@BaseModelNoWithExtra
struct After {
    var A: Int
}
extension After {
    mutating func after() throws {
        self.A = self.A + 100
    }
}

@Suite struct SimpleCodableMacroTests {
    // MARK: - CodableLiteral
    @Test("CodableLiteral Using") func CodableLiteralMacroTest() async throws {
        do {
            let s = "150"
            let literal: Literal = try JSONDecoder().decode(Literal.self ,from: s.data(using: .utf8)!)
            print(literal)
        } catch { print(error) }
    }
    
    // MARK: - SingleOrArray

    @Test("SingleOrArray Using") func SingleOrArrayMacroTest() throws {
        do {
            let content = #"["ABC", "abc"]"#
            let input = try JSONDecoder().decode(Input.self ,from: content.data(using: .utf8)!)
            print(input)
        } catch { print(error) }
    }
    
    // MARK: - CodableByConstant
    @Test("CodableByConstant Using") func CodableByConstantMacroTest() throws {
        let CodableByConstantJson = #"""
        {
            "role": "A",
            "name": "N"
        }
        """#
        let x = try JSONDecoder().decode(X.self, from: CodableByConstantJson.data(using: .utf8)!)
        print(x)
        let y = try JSONEncoder().encode(x)
        print(String(data: y, encoding: .utf8)!)
    }
    
    // MARK: - CodableTraversal
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
    
    // MARK: - BaseModel
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
}
