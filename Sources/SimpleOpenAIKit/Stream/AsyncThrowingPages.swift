//
//  AsyncThrowingPages.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/17/26.
//

public struct AsyncThrowingPages<T: Codable & Sendable>: AsyncSequence {
    public typealias Element = PageStruct<T>
    
    private let fetch: () async throws -> PageStruct<T>
    public init(fetch: @escaping () async throws -> PageStruct<T>) {
        self.fetch = fetch
    }
    public func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(fetch: fetch)
    }
    public struct AsyncIterator: AsyncIteratorProtocol {
        private let fetch: () async throws -> PageStruct<T>
        private var hasMore = true
        
        init(fetch: @escaping () async throws -> PageStruct<T>) {
            self.fetch = fetch
        }
        public mutating func next() async throws -> PageStruct<T>? {
            guard hasMore else { return nil }
            let page = try await fetch()
            hasMore = page.has_more ?? false
            guard !page.data.isEmpty else { return nil }
            return page
        }
    }
}
