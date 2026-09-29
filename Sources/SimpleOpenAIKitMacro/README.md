# SimpleOpenAIKitMacro

Public declarations for the tool-schema macros, re-exported by `SimpleOpenAIKit`. Expansion lives in
[SimpleOpenAIKitMacroPlugin](../SimpleOpenAIKitMacroPlugin/README.md).

| Macro | Effect |
| --- | --- |
| `@MainArgument` | Root `object` JSON Schema on a struct, plus `MainArgument` conformance |
| `@ReferArgument` | A `$def` definition a root schema can reference |
| `@EnumToolArgument` | `{"type": ..., "enum": [...]}` built from an enum's raw values |
| `@AnyOfToolArgument` | `{"anyOf": [...]}` over an enum's cases, plus the matching `init(from:)` |
| `@StringToolArgument`, `@NumberToolArgument`, `@BooleanToolArgument`, `@ArrayToolArgument` | Per-property type, description and constraints |
| `@ReferToolArgument` | Writes a property as `{"$ref": ...}` |

A property with no peer macro is inferred from its Swift type, so a named type has to carry one of the
schema macros itself.

## A root schema

`@MainArgument` on a struct generates `static var ArgumentSchema`, and the JSON below is exactly what
that struct produces:

```swift
@MainArgument
struct Arguments {
    @EnumToolArgument
    enum Tone: String { case calm, angry }

    @StringToolArgument(description: "The city to look up")
    let city: String
    let note: String?
    let days: Int
    let threshold: Double
    let strict: Bool
    let tags: [String]
    let tone: Tone
}
```

```json
{
  "type": "object",
  "properties": {
    "city": { "type": "string", "description": "The city to look up" },
    "note": { "type": "string" },
    "days": { "type": "integer" },
    "threshold": { "type": "number" },
    "strict": { "type": "boolean" },
    "tags": { "type": "array", "items": { "type": "string" } },
    "tone": { "type": "string", "enum": ["calm", "angry"] }
  },
  "required": ["city", "days", "threshold", "strict", "tags", "tone"],
  "additionalProperties": false
}
```

`required` holds every non-optional property, and `additionalProperties` stays `false` even when `extra`
is merged on top: `@MainArgument(extra: ["description": .string("Weather lookup")])`.

## Reuse with `$ref`

Mark a shared type `@ReferArgument` and point at it with `@ReferToolArgument`. The root schema writes a
`"$def"` entry once, however many properties reference it.

```swift
@ReferArgument
struct Location {
    let lat: Float
    let long: Float
}

@MainArgument
struct Argument {
    @ReferToolArgument(description: "The location to fetch the weather for.")
    let location: Location
    let time: Double
}
// location -> {"$ref": "#/$def/Location", "description": "..."}
```

## Constraints

Each peer macro only accepts the Swift type it describes, and rejects anything else at the declaration.

```swift
@MainArgument
struct Filter {
    @StringToolArgument(description: "Host to probe", format: "hostname")
    let host: String

    @NumberToolArgument(description: "Retry count", `default`: 3, minimum: 1, maximum: 5, multipleOf: 1)
    let retries: Int

    @BooleanToolArgument(description: "Fail on the first error")
    let strict: Bool

    @ArrayToolArgument(description: "Tags to match", minItems: 1)
    let tags: [String]
}
```

In strict mode `pattern` and `format` are validated by OpenAI, while `minLength`, `maxLength`, `minItems`
and `maxItems` are not part of what strict mode accepts. Only the labels you actually write appear in the
schema.

## Enums

```swift
// A closed set of literals: {"type": "string", "enum": [...]}
@EnumToolArgument
enum Unit: String { case celsius, fahrenheit }

// One of several shapes: {"anyOf": [...]} plus init(from:)
@AnyOfToolArgument
enum Value {
    @StringToolArgument(description: "Free-form text")
    case text(String)
    case count(Int)
}
```

A `@EnumToolArgument` case without an explicit raw value falls back to its name, or to the previous
value plus one for integer raw types. `@AnyOfToolArgument` cases need distinct associated types, because
decoding tries them in declaration order.

## Handing it to a tool

```swift
struct WeatherTool: ToolProtocol {
    static let name: String = "fetch_weather"
    static let description: String = "Fetch the weather for a given location."
    static let strict: Bool? = true

    @MainArgument
    struct Argument {
        let city: String
        let unit: Unit
    }

    static func call(arguments: Argument) async throws -> String { "sunny" }
}

let chatTool: ChatTool = .init(WeatherTool.self)          // parameters come from Argument.ArgumentSchema
let responseTool: ResponseTool = .init(WeatherTool.self)
let messageTool: MessageTool = .init(WeatherTool.self)
```

The `parameters` each tool sends is `Argument.ArgumentSchema`, so the schema and the decoded argument
type cannot drift apart. See [API](../SimpleOpenAIKit/API/README.md) for the call round trip and
[Utils/ToolProtocol](../SimpleOpenAIKit/Utils/README.md) for handling an incoming call.

`ToolArgumentProtocol.swift` declares what the generated code conforms to: `ArgumentSchema` (can
describe itself as a schema fragment), then `MainArgument`, `ReferArgument`, `EnumArgument` and
`AnyOfArgument`. Each encodes its schema rather than a value, which is how a schema constant reaches
the request body.
