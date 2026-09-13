//
//  EventParser.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/27/26.
//
import Foundation

public protocol CustomParser: Sendable & ~Copyable {
    func parse(_ data: Data) -> [Event]
}

public final class EventParser: CustomParser, @unchecked Sendable {
    private var buffer = Data()
    private static let validNewlineCharacters = ["\r\n", "\n", "\r"]
    private static let delimiters: [Data] = validNewlineCharacters.map { Data("\($0)\($0)".utf8) }
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
