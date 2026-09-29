# Stream

Blocking counterparts of Swift's async sequences, plus pagination iterators.

## Contents

| Type | Meaning |
| --- | --- |
| `SyncSequence`, `SyncIteratorProtocol` | The `AsyncSequence` shape without `await`, carrying an associated `Failure` |
| `SyncStream` | Buffered queue fed by a detached task, drained by a blocking loop |
| `SyncThrowingStream` | Same, with an error delivered to the consumer's `next()` |
| `SyncThrowingPages`, `AsyncThrowingPages` | Iterate a paged endpoint one request per element |

## Rules

- Producers never block: continuations are unbounded, and `yield` after `finish` is ignored.
- Dropping the iterator marks the stream cancelled, which stops the producer through `onTermination`.
- `signal()` exists because a blocking consumer parked on a condition cannot observe cancellation on
  its own; operators call it after cancelling the upstream task.
- In `SyncThrowingStream` buffered elements drain before a failure surfaces, and the error is cleared
  once thrown so a second iteration does not repeat it.
- Pages stop when a page reports `has_more == false` or comes back empty.
