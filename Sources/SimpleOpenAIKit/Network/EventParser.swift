//
//  EventParser.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/27/26.
//
import Foundation

/// Turns streamed bytes into `Event` values. Replace the default to read a non-SSE framing.
public protocol CustomParser: Sendable & ~Copyable {
    /// Consume one chunk and return every event that chunk completes.
    func parse(_ data: Data) -> [Event]
}

/// Incremental SSE parser that holds a partial block until the next chunk arrives.
///
/// Events end at a blank line (`\r\n\r\n`, `\n\n` or `\r\r`) whose fields are read as `event`, `id`,
/// `data` and `retry`. Keep one parser per stream: it buffers across calls and is not reentrant.
public final class EventParser: CustomParser, @unchecked Sendable {
    private var buffer = Data()
    private static let validNewlineCharacters = ["\r\n", "\n", "\r"]
    private static let delimiters: [Data] = validNewlineCharacters.map { Data("\($0)\($0)".utf8) }
    /// Append `data` to the buffer and emit the events it completes.
    public func parse(_ data: Data) -> [Event] {
        buffer.reserveCapacity(buffer.count + data.count)
        buffer.append(data)
        var events: [Event] = []
        var consumed = buffer.startIndex
        while true {
            let foundRange = Self.delimiters.lazy
                .compactMap { self.buffer.range(of: $0, in: consumed..<self.buffer.endIndex) }
                .first
            guard let range = foundRange else { break }
            let block = buffer[consumed..<range.lowerBound]
            events.append(Self.parseBlock(block))
            consumed = range.upperBound
        }
        if consumed > buffer.startIndex { buffer.removeSubrange(buffer.startIndex..<consumed) }
        return events
    }
    /// Read the `key: value` lines of one block, ignoring anything unrecognised.
    private static func parseBlock(_ block: Data) -> Event {
        var event = Event()
        let s = String(decoding: block, as: UTF8.self)

        for line in s.split(whereSeparator: { $0.isNewline }) {
            guard let colon = line.firstIndex(of: ":") else { continue }
            let key = line[..<colon]
            let value = line[line.index(after: colon)...]

            switch key {
            case "event": event.event = String(value)
            case "id": event.id = String(value)
            case "data": event.data = String(value)
            case "retry": event.retry = Int(value)
            default: break
            }
        }
        return event
    }
}
