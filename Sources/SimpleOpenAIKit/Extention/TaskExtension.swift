//
//  TaskExtension.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/2/26.
//
import Foundation

/// Task.sleep(for: .seconds(1) need macOS 13.0 or newer
package extension Task where Success == Never, Failure == Never {
    @usableFromInline
    static func sleep(seconds: TimeInterval) async throws {
        let nanoseconds = UInt64(seconds * 1_000_000_000)
        try await sleep(nanoseconds: nanoseconds)
    }
}
