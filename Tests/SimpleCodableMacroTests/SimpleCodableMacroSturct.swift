//
//  TestFixtures.swift
//  SimpleCodableMacroTests
//
//  Created by snow on 9/10/26.
//

// Types shared by the macro test files.

import Foundation
import Testing
import SimpleCodableMacro

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

@BaseModelNoWithExtra
struct OptionModel {
    var d: Int? = 0
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

@BaseModelNoWithExtra
struct MultiRole {
    let role: String
}

@CodableByConstant(field: "role")
enum Multi {
    @MultiConstant("D", "C")
    case multi(MultiRole)
    @MultiConstant("E")
    case singleValue(MultiRole)
    case a(A)
}

@CodableByConstantAndSingle(field: "role", singleCase: "single")
enum MultiSingle {
    @MultiConstant(["D", "C"])
    case multi(MultiRole)
    case a(A)
    case single(B)
}
