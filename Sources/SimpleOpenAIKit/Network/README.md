# Network

Everything that touches `URLSession`, kept free of provider knowledge.

## Contents

| Path | Meaning |
| --- | --- |
| `URLSessionExtention.swift` | The four primitives: `syncData`, `asyncData`, `syncStreamData`, `asyncStreamData`, plus `syncSSE` / `asyncSSE` |
| `Event.swift`, `EventParser.swift` | Server-sent event value, and the incremental parser behind `CustomParser` |
| `NetworkError.swift` | Transport failures, including the raw body of a non-2xx response |
| `MultipartFormDataEncode.swift` | `multipart/form-data` encoder driven by `Encodable` |
| `InputStream/` | `InputStream` implementations: concatenated parts, and a download-backed stream |

## Rules

- A non-2xx status always surfaces as `NetworkError.statusError(data:request:response:)`; the session
  decides which provider error that becomes.
- Streaming chunks flush on every `\n` as well as at `chunk` bytes, so an SSE line never straddles two
  yields and the parser can emit eagerly.
- `CustomParser` is swappable: pass your own to `syncSSE`/`asyncSSE` for a non-SSE framing.
- Sync calls wrap the async or callback APIs and park on a semaphore for
  `request.timeoutInterval + 1` seconds.
- `MultipartFormDataEncodeContainer.encode(_:)` flattens nested Codable values into bracketed names
  (`files[0]`, `extra[key]`); a `FileParameters` leaf becomes a file part instead of a field.
- With `SelectInputStream` the multipart body is a `ConcatenatedInputStream`, so files stream from disk
  rather than being copied into one `Data`.
