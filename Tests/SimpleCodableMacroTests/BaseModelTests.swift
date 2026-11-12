import Foundation
import Testing
import SimpleCodableMacro

@PublicInit
@BaseModelNoWithExtra
public struct PublicInitValue {
    public let name: String
    public var count: Int?
    public var limit: Int = 10
    public let fixed: String = "fixed"
    public static let role = "struct"
}

@PublicInit
public class PublicInitClassValue {
    public let name: String
    public var count: Int?
    public let fixed: String = "class"
    public static let role = "class"
}

@PublicInit
@BaseModelWithExtra(encodeExtra: false)
struct DiscardingExtraModelValue {
    let id: Int
}

@PublicInit
@BaseModelNoWithExtra
fileprivate struct CustomCodingValue {
    let value: Int

    init(value: Int) {
        self.value = value
    }

    init(from decoder: any Decoder) throws {
        value = 42
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode("custom-\(value)")
    }
}

@Suite
struct BaseModelTests {
    @Test
    func publicInitBuildsStructAndClass() throws {
        let value = PublicInitValue(name: "alpha")
        let classValue = PublicInitClassValue(name: "beta", count: 2)
        let decoded = try TestJSON.decode(
            PublicInitValue.self,
            from: #"{"name":"decoded","limit":20}"#
        )

        #expect(value.name == "alpha")
        #expect(value.count == nil)
        #expect(value.limit == 10)
        #expect(value.fixed == "fixed")
        #expect(classValue.name == "beta")
        #expect(classValue.count == 2)
        #expect(classValue.fixed == "class")
        #expect(decoded.name == "decoded")
        #expect(decoded.limit == 20)
        print(decoded)
    }

    @Test
    func publicInitPreservesCustomInitializer() {
        let value = CustomCodingValue(value: 3)

        #expect(value.value == 3)
    }

    @Test
    func strictFeatureHandlesBindingsDefaultsTransientStaticAndHooks() throws {
        let missing = try TestJSON.decode(
            SharedPayload.self,
            from: #"{"role":"user","content":"hello","transientValue":8,"unknown":true}"#
        )
        let present = try TestJSON.decode(
            SharedPayload.self,
            from: #"{"role":"user","content":"hello","optional":9,"transientValue":4}"#
        )
        let null = try TestJSON.decode(
            SharedPayload.self,
            from: #"{"role":"user","content":"hello","optional":null,"transientValue":2}"#
        )
        let encoded = try TestJSON.object(from: missing)
        let nullEncoded = try TestJSON.object(from: null)
        let encodedOptional: Int? = encoded["optional"]?.value()
        let encodedHookCount: Int? = encoded["hookCount"]?.value()

        #expect(missing.role == "user")
        #expect(missing.content == "hello")
        #expect(missing.optional == 7)
        #expect(missing.transientValue == 8)
        #expect(missing.hookCount == 1)
        #expect(present.optional == 9)
        #expect(null.optional == nil)
        #expect(encodedOptional == 7)
        #expect(encodedHookCount == 11)
        #expect(
            Set(encoded.keys)
                == Set(["role", "content", "optional", "hookCount", "schema"])
        )
        #expect(nullEncoded["optional"] == nil)
        print(missing)
        print(present)
        print(null)
        print(try TestJSON.string(from: missing))
    }

    @Test
    func nestedExtensibleAndEmptyModelsExpandCorrectly() throws {
        let decoded = try TestJSON.decode(
            SharedPayload.ExtensibleValue.self,
            from: #"{"id":5,"name":"two","local":8,"future":6}"#
        )
        let encoded = try TestJSON.object(from: decoded)
        let empty = try TestJSON.decode(EmptyPayload.self, from: "{}")

        #expect(decoded.extra["future"] != nil)
        #expect(Set(encoded.keys) == Set(["id", "name", "schema", "future"]))
        #expect(try TestJSON.object(from: empty).isEmpty)
        print(decoded)
        print(try TestJSON.string(from: decoded))
    }

    @Test
    func extensibleModelCanDiscardUnknownFields() throws {
        let decoded = try TestJSON.decode(
            DiscardingExtraModelValue.self,
            from: #"{"id":3,"future":"ignored"}"#
        )
        let encoded = try TestJSON.object(from: decoded)

        #expect(decoded.id == 3)
        #expect(decoded.extra["future"] != nil)
        #expect(Set(encoded.keys) == Set(["id"]))
        print(try TestJSON.string(from: decoded))
    }

    @Test
    func customCodingMethodsOverrideSynthesis() throws {
        let decoded = try TestJSON.decode(CustomCodingValue.self, from: #"{"value":1}"#)

        #expect(decoded.value == 42)
        #expect(try TestJSON.string(from: decoded) == #""custom-42""#)
        print(decoded)
    }
}
