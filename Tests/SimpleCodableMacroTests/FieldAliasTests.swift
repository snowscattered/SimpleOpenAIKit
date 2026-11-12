import Foundation
import Testing
import SimpleCodableMacro

@PublicInit
@BaseModelWithExtra
struct AliasedFeaturePayload {
    @BaseModelFieldAlias(["beta_realtime", "x-betarealtime"])
    var betaRealtime: Bool?

    @BaseModelFieldAlias("type")
    var type_: String

    @BaseModelFieldAlias("x-timeout")
    var timeout: Int = 30
}

@Suite
struct FieldAliasTests {
    @Test
    func aliasesDecodeAndEncodeCanonicalNames() throws {
        var decoded = try TestJSON.decode(
            AliasedFeaturePayload.self,
            from: #"{"beta_realtime":true,"type_":"object","future":5}"#
        )
        let capturedUnknown = decoded.extra["future"] != nil
        decoded.extra = [:]
        let encoded = try TestJSON.object(from: decoded)

        #expect(decoded.betaRealtime == true)
        #expect(decoded.type_ == "object")
        #expect(capturedUnknown)
        #expect(Set(encoded.keys) == Set(["betaRealtime", "type_", "timeout"]))
        print(decoded)
        print(try TestJSON.string(from: decoded))
    }

    @Test
    func propertyNameWinsAndFallbackAliasesWork() throws {
        let prioritized = try TestJSON.decode(
            AliasedFeaturePayload.self,
            from: #"{"betaRealtime":false,"beta_realtime":true,"type_":"object"}"#
        )
        let fallback = try TestJSON.decode(
            AliasedFeaturePayload.self,
            from: #"{"x-betarealtime":true,"type":"text","x-timeout":7}"#
        )
        let defaults = try TestJSON.decode(
            AliasedFeaturePayload.self,
            from: #"{"type_":"text"}"#
        )

        #expect(prioritized.betaRealtime == false)
        #expect(fallback.betaRealtime == true)
        #expect(fallback.type_ == "text")
        #expect(fallback.timeout == 7)
        #expect(defaults.timeout == 30)
        print(prioritized)
        print(fallback)
        print(defaults)
    }

    @Test
    func missingRequiredAliasThrows() {
        #expect(throws: (any Error).self) {
            try TestJSON.decode(
                AliasedFeaturePayload.self,
                from: #"{"beta_realtime":true}"#
            )
        }
    }
}
