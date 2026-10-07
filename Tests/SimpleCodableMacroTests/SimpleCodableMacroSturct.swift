//
//  TestFixtures.swift
//  SimpleCodableMacroTests
//
//  Created by snow on 9/10/26.
//

// Types shared by the macro test files.

import Foundation
import SimpleCodableMacro

@CodableLiteral
enum IntLiteral: Int {
    case oneHundred = 100
    case twoHundred = 210
}
@CodableLiteral
enum StringLiteral: String {
    case A, `func`, `A-A`
}

@CodableStringLiteralWithOther
enum CodableStringLiteralStruct {
    case a, b, c, `func`, `a-b`
    case other(String)
}

@SingleOrArray
enum Input {
    case string(String)
    case array([Int])
}

@BaseModelNoWithExtra
@PublicInit
struct A {
    static let role: String = "A"
    let name: String
}

@PublicInit
public struct PublicInitModel {
    public let name: String
    public var count: Int?
    public let object: String = "public_init"
    public static let role: String = "public_init"
}

@PublicInit
public class PublicInitClass {
    public let name: String
    public var count: Int?
    public let object: String = "public_init_class"
    public static let role: String = "public_init_class"
}

@BaseModelNoWithExtra
@PublicInit
struct B {
    static let role: String = "B"
    let age: Int
}

@BaseModelNoWithExtra
@PublicInit
struct C {
    static let role: String = "C"
    let score: Double
}

@BaseModelWithExtra
@PublicInit
struct Other: Codable {
    var role: String
}

@BaseModelNoWithExtra
@PublicInit
struct OptionModel {
    var d: Int? = 0
}

@CodableByConstant(field: "role", defaultCase: "other")
enum CodableConstantStruct {
    case a(A)
    case b(B)
    case c(C)
    case other(Other)
}

@CodableTraversal
enum CodableTraversalStruct {
    case a(A)
    case b(B)
    case c(C)
    case other(Other)
}

@BaseModelNoWithExtra
@PublicInit
struct Fast {
    let A: Int
    @transient let B: Int
}

@BaseModelWithExtra
@PublicInit
struct Extra {
    let A: Int
}

@BaseModelNoWithExtra
@PublicInit
struct After {
    var A: Int
}

extension After {
    mutating func after() throws {
        self.A = self.A + 100
    }
}

@BaseModelNoWithExtra
@PublicInit
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

// MARK: - @BaseModelFieldAlias
@BaseModelWithExtra
@PublicInit
struct AliasedExtra {
    @BaseModelFieldAlias("x-schema")
    var schema_: [String: BaseType]?
    @BaseModelFieldAlias(["beta_realtime", "x-betarealtime"])
    var betaRealtime: Bool?
    @BaseModelFieldAlias("x-timeout")
    var timeout: Int = 30
    var name: String?
}

@BaseModelWithExtra
@PublicInit
struct AliasedSchema {
    @BaseModelFieldAlias("schema_")
    var schema: [String: BaseType]?
}

@BaseModelNoWithExtra
@PublicInit
struct AliasedPlain {
    @BaseModelFieldAlias("type")
    var type_: String
    @BaseModelFieldAlias(["match_aliases", "matchAliases"])
    var aliases: [String]?
}

// Keys Swift cannot spell as a case name directly: hyphen, keyword, dotted path.
@BaseModelNoWithExtra
@PublicInit
struct AliasedNames {
    @BaseModelFieldAlias("beta_realtime")
    var betaRealtime: Bool?
    @BaseModelFieldAlias("default")
    var defaultValue: String?
    @BaseModelFieldAlias("item.input_audio_transcription.logprobs")
    var logprobs: Int?
    @BaseModelFieldAlias("item.logprobs")
    var a: Int?
    @BaseModelFieldAlias("item_logprobs")
    var b: Int?
}

@BaseModelNoWithExtra
@PublicInit
struct MultiBindingModel {
    var first: Int
    var second: String
}

@BaseModelNoWithExtra
struct EscapedPropertyModel {
    @BaseModelFieldAlias("legacy-default")
    var `default`: String?
}
