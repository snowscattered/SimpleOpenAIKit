//
//  EventParser.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/27/26.
//
import Foundation

public protocol CustomParser: Sendable & ~Copyable {
    mutating func parse(_ data: Data) -> [Event]
}

final class EventParser: CustomParser, @unchecked Sendable {
    private var buffer = Data()
    private static let validNewlineCharacters = ["\r\n", "\n", "\r"]
    
    func parse(_ data: Data) -> [Event] {
        buffer.append(data)
        var events: [Event] = []
        let delimiters = EventParser.validNewlineCharacters.map { "\($0)\($0)".data(using: .utf8)! }
        while let delimiter = delimiters.first(where: { buffer.range(of: $0) != nil }),
              let range = buffer.range(of: delimiter) {
            let block = buffer.subdata(in: 0..<range.lowerBound)
            if let event  = EventParser.parseBlock(block) {
                events.append(event)
            }
            buffer.removeSubrange(0..<range.upperBound)
        }
        return events
    }
    private static func parseBlock(_ block: Data) -> Event? {
        guard let eventString = String(data: block, encoding: .utf8) else { return nil }
        var event: Event = .init()
        for line in eventString.components(separatedBy: CharacterSet.newlines) {
            var key: String?, value: String?
            let scanner = Scanner(string: line)
            
            key = scanner.scanUpToString(":")
            let _ = scanner.scanString(":")
            
            for newline in self.validNewlineCharacters {
                if let scannedValue = scanner.scanUpToString(newline) {
                    value = scannedValue
                    break
                }
            }
            switch key {
            case "event": event.event = value
            case "id": event.id = value
            case "data": event.data = value
            case "retry": event.retry = Int(value ?? "")
            default : break
            }
        }
        return event
    }
}
