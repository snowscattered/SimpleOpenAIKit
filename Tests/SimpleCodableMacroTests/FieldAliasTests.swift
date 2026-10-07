//
//  FieldAliasTests.swift
//  SimpleCodableMacroTests
//
//  Created by snow on 10/7/26.
//

import Foundation
import Testing
import SimpleCodableMacro

@Suite struct FieldAliasTests {
    @Test("Alias keys decode and encode") func aliasRoundTripTest() throws {
        var model = try JSONDecoder().decode(
            AliasedExtra.self,
            from: Data(#"{"x-schema":{"a":1},"beta_realtime":true,"name":"n","unknown":5}"#.utf8)
        )
        #expect(model.schema_?["a"] != nil)
        #expect(model.betaRealtime == true)
        #expect(Set(model.extra.keys) == Set(["unknown"]))

        model.extra = [:]
        let encoded = try JSONDecoder().decode(
            [String: BaseType].self,
            from: Data(try model.json().utf8)
        )
        #expect(Set(encoded.keys) == Set(["schema_", "betaRealtime", "timeout", "name"]))
        #expect(encoded["x-schema"] == nil)
        #expect(encoded["beta_realtime"] == nil)

        let legacy = try JSONDecoder().decode(
            AliasedExtra.self,
            from: Data(#"{"schema_":{"b":2},"x-betarealtime":false,"timeout":7}"#.utf8)
        )
        #expect(legacy.schema_?["b"] != nil)
        #expect(legacy.betaRealtime == false)
        #expect(legacy.timeout == 7)
        #expect(legacy.extra.isEmpty)

        let empty = try JSONDecoder().decode(AliasedExtra.self, from: Data("{}".utf8))
        #expect(empty.timeout == 30)
    }

    @Test("Renamed and array aliases") func fieldAliasVariantsTest() throws {
        let renamed = try JSONDecoder().decode(
            AliasedSchema.self,
            from: Data(#"{"schema_":{"type":"object"}}"#.utf8)
        )
        #expect(renamed.schema?["type"] != nil)

        let plain = try JSONDecoder().decode(
            AliasedPlain.self,
            from: Data(#"{"type_":"text","matchAliases":["a"]}"#.utf8)
        )
        #expect(plain.type_ == "text")
        #expect(plain.aliases == ["a"])

        let encoded = try JSONDecoder().decode(
            [String: BaseType].self,
            from: Data(try plain.json().utf8)
        )
        #expect(encoded["type_"] != nil)
        #expect(encoded["type"] == nil)

        #expect(throws: (any Error).self) {
            _ = try JSONDecoder().decode(AliasedPlain.self, from: Data(#"{"match_aliases":[]}"#.utf8))
        }
    }

    @Test("Escaped and mangled keys") func escapedAndMangledKeysTest() throws {
        let model = try JSONDecoder().decode(
            AliasedNames.self,
            from: Data(#"{"beta_realtime":true,"betaRealtime":false,"default":"d","item.input_audio_transcription.logprobs":7}"#.utf8)
        )
        #expect(model.betaRealtime == false)
        #expect(model.defaultValue == "d")
        #expect(model.logprobs == 7)

        let mangled = try JSONDecoder().decode(
            AliasedNames.self,
            from: Data(#"{"item.logprobs":1,"item_logprobs":2}"#.utf8)
        )
        #expect(mangled.a == 1)
        #expect(mangled.b == 2)
        let encoded = try JSONDecoder().decode(
            [String: BaseType].self,
            from: Data(try mangled.json().utf8)
        )
        #expect(Set(encoded.keys) == Set(["a", "b"]))
    }
}
