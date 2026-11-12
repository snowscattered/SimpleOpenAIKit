import Foundation
import SimpleCodableMacro

enum TestJSON {
    static func decode<T: Decodable>(_ type: T.Type, from json: String) throws -> T {
        try JSONDecoder().decode(type, from: Data(json.utf8))
    }

    static func string(from value: some Encodable) throws -> String {
        String(decoding: try JSONEncoder().encode(value), as: UTF8.self)
    }

    static func object(from value: some Encodable) throws -> [String: BaseType] {
        try decode([String: BaseType].self, from: string(from: value))
    }
}

@BaseModelNoWithExtra
struct EmptyPayload {}

@PublicInit
@BaseModelNoWithExtra
struct SharedPayload {
    var role: String
    var content: String
    var optional: Int? = 7
    @transient var transientValue: Int = 0
    var hookCount: Int = 0
    static let schema: String = "shared"

    @PublicInit
    @BaseModelWithExtra
    struct ExtensibleValue {
        let id: Int
        var name: String?
        @transient var local: Int
        static let schema: String = "nested"
    }
}

extension SharedPayload {
    mutating func afterDecode() {
        hookCount += 1
    }

    mutating func beforeEncode() {
        hookCount += 10
    }
}
