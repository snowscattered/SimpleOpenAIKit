# Client

Public entry points and the transport contract behind every API call.

## Contents

| Path | Meaning |
| --- | --- |
| `OpenAI/`, `Anthropic/`, `TypeSafe/` | Per provider: client class, `ClientOption`, `Session` |
| `APIClientOption.swift` | Configuration protocol: `api_key`, `base_url`, `timeout`, `max_retries`, `headers`, `query` |
| `SessionProtocol.swift` | Request building, the four call shapes, retry and error-wrapping hooks |

`OpenAI` and `AsyncOpenAI` (likewise `Anthropic`/`AsyncAnthropic`, `TypeSafeClient`/`AsyncTypeSafeClient`)
expose resources as stored lets, all sharing one `ClientOption` built in `init`.

## Creating a client

Every client takes credentials plus endpoint and transport knobs, and each of those reads back off the
client as a property.

```swift
import Foundation
import SimpleOpenAIKit

let openAI = AsyncOpenAI(api_key: "YOUR_API_KEY")

let gateway = AsyncOpenAI(
    api_key: "YOUR_API_KEY",
    organization: "org_...",
    project: "proj_...",
    webhook_secret: "whsec_...",
    base_url: URL(string: "https://your-gateway.example.com/v1")!,
    websocket_base_url: URL(string: "wss://your-gateway.example.com/v1")!,
    timeout: 600,
    max_retries: 2,
    default_headers: ["User-Agent": "my-app/2.0"],
    default_query: ["trace": .string("abc")]
)
print(gateway.base_url, gateway.max_retries, gateway.headers)

let anthropic = AsyncAnthropic(api_key: "YOUR_ANTHROPIC_API_KEY")
let typeSafe = AsyncTypeSafeClient(api_key: "YOUR_TYPESAFE_API_KEY", model: "jev-latest")
```

| Client | Default `base_url` | Other defaults |
| --- | --- | --- |
| `OpenAI`, `AsyncOpenAI` | `https://api.openai.com/v1` | `wss://api.openai.com/v1`, `timeout: 600`, `max_retries: 2` |
| `Anthropic`, `AsyncAnthropic` | `https://api.anthropic.com` | `timeout: 600`, `max_retries: 2` |
| `TypeSafeClient`, `AsyncTypeSafeClient` | `https://api.typesafe.ai` | `model: "jev-latest"`, `timeout: 600`, `max_retries: 2` |

The sync and async clients are separate types, so a blocking script and a `Task` never share one.

## How a request's headers come together

`ClientOption.headers` is rebuilt per call, in this order:

```text
User-Agent (library default)  ->  | default_headers  ->  Accept, Content-Type  ->  Organization, Project  ->  Authorization
```

Anything written after the merge wins, so `default_headers` can replace `User-Agent` but not
`Accept`, `Content-Type` or `Authorization` — and not `OpenAI-Organization`/`OpenAI-Project` either when
the client was given those values.

Anthropic authenticates with the same `Authorization: Bearer` scheme as OpenAI. `auth_token` is stored
and readable but currently never reaches a header, and no `anthropic-version` header is sent, so a
caller who needs either must pass it through `default_headers`.

## Per-call overrides

`RequestOptions` is the only per-call configuration, always passed as the trailing `requestOptions:`
argument. Client defaults and per-call extras merge with the extras winning.

```swift
let response = try await openAI.responses.create(
    parameters: .init(model: "your-model", input: "who are you?"),
    requestOptions: .init(
        extra_body: ["include": .array([.string("usage")])],
        extra_headers: ["X-Trace": "1"],
        extra_query: ["debug": .bool(true)],
        timeout: 30
    )
)
```

For a GET the payload's own JSON keys are folded into the query string, which is why list endpoints take
filters as parameters rather than a body. `extra_body` is still sent as a body even on a GET.

> **Note**: `RequestOptions`' members are not `public` today, so this struct can only be built from
> inside the module. The names above are the intended surface.

## Retry and error mapping

Each session decides which failures are worth another attempt; the loop itself lives in `Utils.retry`
and backs off exponentially, capped at 8 seconds.

| Session | Retried |
| --- | --- |
| `OpenAISession` | `429`, `5xx`, client-side `URLError.timedOut` |
| `AnthropicSession` | `429`, `503`, `504`, `529`, other `5xx`, `URLError.timedOut` |
| `TypeSafeSession` | `408`, `429`, `529`, `5xx`, `URLError.timedOut` |

Transport failures arrive as `NetworkError.statusError`, and each session maps the status code onto its own
error enum carrying the request, the response, and an error payload whose `message` is the raw body text.
`max_retries` counts extra attempts after the first one, so `max_retries: 2` means up to three calls.

```swift
do {
    _ = try await openAI.chat.completions.create(
        parameters: .init(model: "your-model", messages: [.user("Hello!")])
    )
} catch let error as OpenAIAPIError {
    // badRequest / authentication / permissionDenied / notFound / conflict /
    // unprocessableEntity / rateLimit / internalServer / unexpectedStatusCode
    print(error)
}
```

## Rules

- Sync and async are separate types, never a flag on one type.
- Sessions are stateless `static let shared` values; all configuration travels in `ClientOption`,
  which is `~Copyable` and borrowed per call.
- `<Provider>Session` owns two decisions only: which errors retry (`retryErrorHandler`) and how a
  status code becomes a provider error (`wrapError`). Everything else is the protocol default.
- `ClientOption.headers` rebuilds per call; see the merge order above.
- Streaming calls retry the connection attempt only. Chunks already handed to a consumer are never
  replayed, so a mid-stream failure surfaces once and iteration ends.
- Adding a provider means: one `ClientOption`, one `Session`, one namespace enum per call style.
