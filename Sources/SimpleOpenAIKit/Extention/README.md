# Extention

Extensions on Foundation and stdlib types, kept here because the library leans on them everywhere.

| Path | Adds |
| --- | --- |
| `CollectionExtension.swift` | The `lhs \| rhs` dictionary merge behind header and query defaults |
| `TaskExtension.swift` | `Task.sleep(seconds:)`, avoiding the `Duration` overload that needs macOS 13 |
| `IOExtension.swift` | `Data` and `InputStream` readers, `Stream.with`, `OutputStream` writers |
| `StreamExtension.swift` | `StreamAction` and `conversion(...)` for `AsyncSequence` and `SyncSequence`, plus `write(to:)` |

## Notes

- Merging is right-biased: the second dictionary wins per key, which is what lets a client's defaults be
  overridden per call.
- `conversion(_:)` is the streaming pipeline's map/filter/first: `transform` returns a `StreamAction`
  per element, so a chunk can be dropped, turned into several events, or end the stream.
- `forEach` stops when the body returns `nil`, which is the synchronous equivalent of `break` in a loop.
- `write(to:)` accepts a file URL only and streams chunk by chunk, checking cancellation.
