# SimpleCodableMacro

Public declarations for the Codable helpers the library uses to describe API payloads. Everything is
re-exported by `SimpleOpenAIKit`; expansion lives in
[SimpleCodableMacroPlugin](../SimpleCodableMacroPlugin/README.md).

| Macro | Effect |
| --- | --- |
| `@BaseModelNoWithExtra` | Codable synthesis over exactly the declared fields |
| `@BaseModelWithExtra` | Same, routing unknown JSON keys into `extra` |
| `@BaseModelFieldAlias` | Adds alternate JSON key spellings for a stored property |
| `@PublicInit` | Public initializer over the stored properties |
| `@SingleOrArray` | Accepts one value or an array when decoding |
| `@CodableLiteral` | Literal-style Codable synthesis for an enum's cases |
| `@CodableStringLiteralWithOther` | String literals for known cases, catch-all for unknown ones |
| `@CodableByConstant` | Identifies a case by a constant string |
| `@CodableByConstantAndSingle` | As above, with a single-value fallback |
| `@CodableTraversal` | Walks nested members instead of hand-written coding keys |
| `@MultiConstant` | Several constant spellings for one case |
| `@transient` | Keeps a property out of coding |

## Model structs

Almost every payload in `Types` is one of these two shapes, paired with `@PublicInit` so callers get a
public initializer.

```swift
@BaseModelNoWithExtra
@PublicInit
public struct MessageCacheControlEphemeral {
    public static let type: String = "ephemeral"
    public var ttl: MessageCacheControlTTL        // a `@CodableLiteral` enum, so `"5m"` decodes
}

@BaseModelWithExtra
@PublicInit
public struct VideoListParameter {
    public var after: String?
    public var limit: Int?
    public var order: ListOrder?
}

let list = VideoListParameter(limit: 10)
print(list.json())          // BaseModel helper: sorted, pretty-printed JSON
```

`@BaseModelWithExtra` is the same plus a generated `var extra: [String: BaseType]` that collects the JSON
keys the struct does not declare, so a provider can add fields without breaking decoding. `extra` is
decode-only: it is not a parameter of the generated initializer and is not encoded back.

`after()` is the decode hook. Override it to normalise what came in:

```swift
@BaseModelNoWithExtra
@PublicInit
struct After {
    var A: Int
}
extension After {
    mutating func after() throws { self.A += 100 }
}
```

## Field aliases

`@BaseModelFieldAlias` lets a stored property accept additional JSON key spellings while keeping its
Swift property name as the canonical key:

```swift
@BaseModelWithExtra
@PublicInit
public struct Schema {
    @BaseModelFieldAlias("x-schema")
    public var schema_: [String: BaseType]?

    @BaseModelFieldAlias(["beta_realtime", "x-betarealtime"])
    public var betaRealtime: Bool?
}
```

Decoding checks the Swift property name first, then the aliases in declaration order. Encoding always
writes the Swift property name, so alias keys are decode-only. Alias keys that are not valid Swift
identifiers, such as `x-schema` or `item.input_audio.logprobs`, are emitted as escaped or mangled
`CodingKeys` cases while preserving their original JSON spelling.

Two properties cannot claim the same JSON key, and a type that declares its own `CodingKeys` keeps
full control over alias handling.

## `@PublicInit` parameters

The generated initializer mirrors Swift's memberwise one: `static` members and `let` members that
already have a value are left out, a `var` keeps its declared default, and an optional without a default
gets `nil`.

```swift
@BaseModelNoWithExtra
@PublicInit
public struct ResponseToolChoiceShell {
    public static let type: String = "shell"      // the only member, so this becomes `init()`
}

@BaseModelNoWithExtra
@PublicInit
public struct VideoEditParameter {
    public var prompt: String
    public var video: VideoVideo                  // named type, decoded through its own macros
}
// -> public init(prompt: String, video: VideoVideo)
```

A type whose properties all carry defaults can then be built with no arguments at all:

```swift
@PublicInit
public struct PerCallOptions {           // illustrative shape, not a library type
    public var extra_body: Body = [:]
    public var extra_headers: Header = [:]
    public var timeout: TimeInterval?
}
// -> public init(extra_body: Body = [:], extra_headers: Header = [:], timeout: TimeInterval? = nil)
```

Types that declare their own `init` are skipped, so the macro never creates an ambiguous overload.

## Literal enums

`@CodableLiteral` decodes a JSON string or number straight into a case, with no raw-value boilerplate:

```swift
@CodableLiteral
public enum MessageStopReason: String {
    case end_turn, max_tokens, stop_sequence, tool_use
}
```

When the provider can send values you have not listed, `@CodableStringLiteralWithOther` keeps them
instead of failing the whole decode, and also synthesises `rawValue`:

```swift
@CodableStringLiteralWithOther
public enum VideoSeconds {
    case `4`, `8`, `12`
    case other(String)
}
```

## One value or an array

`@SingleOrArray` decodes a field the provider sends either as a single object or as a list, and encodes
whichever case you built. The literal conformances are hand-written, which is what makes call sites read
like plain strings:

```swift
@SingleOrArray
public enum MessageSystem {
    case string(String)
    case array([MessageTextBlock])
}
extension MessageSystem: ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
    public init(stringLiteral value: String)                { self = .string(value) }
    public init(arrayLiteral elements: MessageTextBlock...) { self = .array(elements) }
}

let system: MessageSystem = "Answer briefly."
```

## Sum types

Three ways to decode one of several shapes:

```swift
// 1. By a discriminator field: each case's type declares `static let type`; `singleCase` also accepts a
//    bare value, and `defaultCase` absorbs anything unmatched.
@BaseModelNoWithExtra
@PublicInit
public struct ResponseToolChoiceShell {
    public static let type: String = "shell"
}

@CodableByConstantAndSingle(singleCase: "option", defaultCase: "types")   // field defaults to "type"
public enum ResponseToolChoice {
    case option(ResponseToolChoiceOptions)
    case types(ResponseToolChoiceTypes)
    case shell(ResponseToolChoiceShell)
}

// 2. When the discriminator is not one constant per case, name its spellings on the case itself.
@CodableByConstant(nilCase: "tool", still: true)
public enum MessageTool {
    @MultiConstant("custom")
    case tool(MessageBaseTool)
    @MultiConstant(["web_search_20250305", "web_search_20260209"])
    case web_search(MessageWebSearchTool)
}

// 3. No discriminator at all: try each case's type in declaration order, first hit wins.
@CodableTraversal
public enum SystemOneJSONConent {
    case string(String)
    case array([BaseType?])
    case dict([String: BaseType?])
}
```

`@CodableByConstant` takes `field:`, `nilCase:`, `still:` and `defaultCase:`;
`@CodableByConstantAndSingle` takes `field:`, `singleCase:` and `defaultCase:` and additionally tries a
bare value against `singleCase` before looking at the keyed container. Order matters for
`@CodableTraversal` because a case that decodes too eagerly hides the ones after it.

## `@transient`

Marks a property that belongs to the Swift value but not to its JSON body.

```swift
@BaseModelWithExtra
@PublicInit
public struct VideoDeleteParameter {
    @transient public var video_id: String
}

// The id stays on the value you construct and is left out of the encoded body, because the endpoint
// takes it from the URL (`/videos/{video_id}`).
```

`@transient` only removes a property from coding. It is still a stored property, so `@PublicInit` keeps
it: `VideoDeleteParameter(video_id: "vid_1")` is how you build one.

`BaseType.swift` holds the shared value types: `BaseType`, any JSON value and literal-expressible, plus
the `BaseModel` protocols these macros conform models to.
