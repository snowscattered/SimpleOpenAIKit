//
//  TaskExtension.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/2/26.
//
import Foundation

/// Task.sleep(for: .seconds(1) need macOS 13.0 or newer
extension Task where Success == Never, Failure == Never {
    /// Await `seconds` through the nanosecond overload, since `sleep(for:)` needs macOS 13.
    @usableFromInline
    static func sleep(seconds: TimeInterval) async throws {
        let nanoseconds = UInt64(seconds * 1_000_000_000)
        try await sleep(nanoseconds: nanoseconds)
    }
}
