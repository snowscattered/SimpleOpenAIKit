# SimpleOpenAIKitMacro

Public declarations for the tool-schema macros, re-exported by `SimpleOpenAIKit`. Expansion lives in
[SimpleOpenAIKitMacroPlugin](../SimpleOpenAIKitMacroPlugin/README.md).

| Macro | Effect |
| --- | --- |
| `@MainArgument` | Root `object` JSON Schema, plus `MainArgument`, `__name`, `__description` and `__strict` |
| `@ReferArgument` | A `$def` definition a root schema can reference |
| `@EnumToolArgument` | `{"type": ..., "enum": [...]}` built from an enum's raw values |
| `@AnyOfToolArgument` | `{"anyOf": [...]}` over an enum's cases, plus the matching `init(from:)` |
| `@ArgumentDescription` | The `description` of one value; works alone or next to a type marker |
| `@StringToolArgument`, `@NumberToolArgument`, `@BooleanToolArgument`, `@ArrayToolArgument` | Per-property type and constraints |
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

    @ArgumentDescription("The city to look up")
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
    @ArgumentDescription("The location to fetch the weather for.")
    @ReferToolArgument
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
    @ArgumentDescription("Host to probe")
    @StringToolArgument(format: "hostname")
    let host: String

    @ArgumentDescription("Retry count")
    @NumberToolArgument(`default`: 3, minimum: 1, maximum: 5, multipleOf: 1)
    let retries: Int

    @ArgumentDescription("Fail on the first error")
    @BooleanToolArgument
    let strict: Bool

    @ArgumentDescription("Tags to match")
    @ArrayToolArgument(minItems: 1)
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
    @ArgumentDescription("Free-form text")
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

A `@MainArgument` struct is a structured output as soon as it declares `SchemaProtocol`: the macro
already writes that protocol's `__name`, `__description` and `__strict` next to the schema, and the
`MainArgument` conformance codes the struct, so one type is both what the request describes and what
the answer decodes into. The `__` prefix is what keeps those three apart from the `name`, `description`
and `strict` a `ToolProtocol` declares, and from the properties of the payload; a tool that says nothing
about strictness falls back to `Arguments.__strict`. A referenced definition needs nothing more than
`@ReferArgument`. See [API / Structured Outputs](../SimpleOpenAIKit/API/README.md).
