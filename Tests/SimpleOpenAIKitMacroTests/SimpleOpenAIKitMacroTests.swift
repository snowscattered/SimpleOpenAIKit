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
        @ArgumentDescription("DA")
        case a(String)
        case b(Int)
    }
    
    @ArgumentDescription("AA")
    let Arg1: String
    let Arg2: String?
    let Arg3: Int
    let Arg4: Double
    let Arg5: Bool
    
    let Arg6: [String]
    let Arg7: [Int]

    @ArgumentDescription("EA Type")
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
//    "Arg8": { "type": "string", "enum": ["A", "B"], "description": "EA Type" },
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
@Test func verifyADecode() async throws {
    let json = """
    {
        "Arg1": "Hello",
        "Arg2": null,
        "Arg3": 42,
        "Arg4": 3.14,
        "Arg5": true,
        "Arg6": ["a", "b", "c"],
        "Arg7": [1, 2, 3],
        "Arg8": "A",
        "Arg9": 2, 
        "Arg10": "some string",
        "Arg11": 1.0
    }
    """.data(using: .utf8)!
    
    let decoder = JSONDecoder()
    let a = try decoder.decode(A.self, from: json)
    print(a)
}

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
    @ArgumentDescription("AA Type")
    @ReferToolArgument
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
@Test func verifyBDecode() async throws {
    let json = """
    {
        "aa": { "Arg1": "mainAA" },
        "ab": { "aa": { "Arg1": "abAA" } },
        "ac": { "aa": { "Arg1": "acAA" } }
    }
    """.data(using: .utf8)!
    
    let decoder = JSONDecoder()
    let b = try decoder.decode(B.self, from: json)
    print(b)
}

@ReferArgument
struct WeatherLocation {
    let lat: Float
    let long: Float
}
@MainArgument(strict: nil)
struct Weather {
    @ArgumentDescription("The location to fetch the weather for.")
    @ReferToolArgument
    let location: WeatherLocation
    let time: Double
}
@Test func verifySchema() async throws {
    let encoder = JSONEncoder()
    // Sorted keys keep the printed schema stable between runs.
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    let Str: String = String(data: try encoder.encode(Weather.ArgumentSchema), encoding: .utf8)!
    print(Str)
    // The metadata a provider takes next to the schema, and the payload type the response decodes into.
    print(Weather.__name, Weather.__description ?? "", Weather.__strict as Any)
    // The struct is its own payload type, so the answer the schema describes decodes into it.
    let json = Data(#"{"location":{"lat":40.7128,"long":-74.006},"time":5}"#.utf8)
    print(try JSONDecoder().decode(Weather.self, from: json))
}
// Output:
//{
//  "$def" : {
//    "WeatherLocation" : {
//      "additionalProperties" : false,
//      "properties" : {
//        "lat" : {
//          "type" : "number"
//        },
//        "long" : {
//          "type" : "number"
//        }
//      },
//      "required" : [
//        "lat",
//        "long"
//      ],
//      "type" : "object"
//    }
//  },
//  "additionalProperties" : false,
//  "properties" : {
//    "location" : {
//      "$ref" : "#\/$def\/WeatherLocation",
//      "description" : "The location to fetch the weather for."
//    },
//    "time" : {
//      "type" : "number"
//    }
//  },
//  "required" : [
//    "location",
//    "time"
//  ],
//  "type" : "object"
//}
//Weather Fetch the weather for a given location. Optional(true)
//Weather(location: SimpleOpenAIKitMacroTests.WeatherLocation(lat: 40.7128, long: -74.006), time: 5.0)
