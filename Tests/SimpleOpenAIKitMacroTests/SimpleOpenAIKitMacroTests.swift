//
//  SimpleOpenAIKitMacroTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/6/26.
//

import Foundation
import Testing
import SimpleOpenAIKitMacro

@MainArgument
struct A {
    @EnumToolArgument
    enum EA: String {
        case A, B
    }
    @EnumToolArgument
    enum EB: Int {
        case a = 1
        case b = 2
    }
    @EnumToolArgument
    enum EC: Double {
        case a = 1.0
        case b = 2.0
    }
    @AnyOfToolArgument
    enum D {
        @StringToolArgument(description: "DA")
        case a(String)
        case b(Int)
    }
    
    @StringToolArgument(description: "AA")
    let Arg1: String
    let Arg2: String?
    let Arg3: Int
    let Arg4: Double
    let Arg5: Bool
    
    let Arg6: [String]
    let Arg7: [Int]

    let Arg8: EA
    let Arg9: EB
    
    let Arg10: D
    let Arg11: EC
}
@Test func verifyArgument() async throws {
    let Str: String = String(data: try JSONEncoder().encode(A.ArgumentSchema), encoding: .utf8)!
    print(Str)
}
// Output:
//{
//  "type": "object",
//  "properties": {
//    "Arg1": { "type": "string", "description": "AA" },
//    "Arg2": { "type": "string" },
//    "Arg3": { "type": "integer" },
//    "Arg4": { "type": "number" },
//    "Arg5": { "type": "boolean" },
//    "Arg6": { "type": "array", "items": { "type": "string" } },
//    "Arg7": { "type": "array", "items": { "type": "integer" } },
//    "Arg8": { "type": "string", "enum": ["A", "B"] },
//    "Arg9": { "type": "integer", "enum": [1, 2] },
//    "Arg10": {
//      "anyOf": [
//        { "type": "string", "description": "DA" },
//        { "type": "integer" }
//      ]
//    },
//    "Arg11": { "type": "number", "enum": [1, 2] }
//  },
//  "required": [
//    "Arg1", "Arg3", "Arg4", "Arg5", "Arg6",
//    "Arg7", "Arg8", "Arg9", "Arg10", "Arg11"
//  ],
//  "additionalProperties": false
//}

@ReferArgument
struct AA {
    let Arg1: String
}
@Test func verifyReferArgument() async throws {
    let Str: String = String(data: try JSONEncoder().encode(AA.ArgumentSchema), encoding: .utf8)!
    print(Str)
}
// Output:
//{
//    "type": "object",
//    "properties": {
//        "Arg1": { "type": "string" }
//    },
//    "required": [ "Arg1" ],
//    "additionalProperties": false
//}

@ReferArgument
struct AC {
    @ReferToolArgument
    let aa: AA
}
@MainArgument
struct B {
    @ReferArgument
    struct AA {
        let Arg1: String
    }
    @ReferArgument
    struct AB {
        @ReferToolArgument
        let aa: AA
    }
    @ReferToolArgument(description: "AA Type")
    let aa: AA
    @ReferToolArgument
    let ab: AB
    @ReferToolArgument
    let ac: AC
}

@Test func verifyMainReferArgument() async throws {
    let Str: String = String(data: try JSONEncoder().encode(B.ArgumentSchema), encoding: .utf8)!
    print(Str)
}
// Output:
//{
//    "type": "object",
//    "properties": {
//        "aa": {
//            "$ref": "#/$def/AA",
//            "description": "AA Type"
//        },
//        "ab": { "$ref": "#/$def/AB" },
//        "ac": { "$ref": "#/$def/AC" }
//    },
//    "required": [ "aa", "ab", "ac" ],
//    "additionalProperties": false,
//    "$def": {
//        "AA": {
//            "type": "object",
//            "properties": {
//                "Arg1": { "type": "string" }
//            },
//            "required": [ "Arg1" ],
//            "additionalProperties": false
//        },
//        "AB": {
//            "type": "object",
//            "properties": {
//                "aa": { "$ref": "#/$def/AA" }
//            },
//            "required": [ "aa" ],
//            "additionalProperties": false
//        },
//        "AC": {
//            "type": "object",
//            "properties": {
//                "aa": { "$ref": "#/$def/AA" }
//            },
//            "required": [ "aa" ],
//            "additionalProperties": false
//        }
//    }
//}
