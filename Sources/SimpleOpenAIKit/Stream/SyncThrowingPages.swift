//
//  SyncThrowingPages.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/17/26.
//

/// Blocking page iterator: calls `fetch` again for every element until a page reports `has_more` false
/// or arrives empty.
public struct SyncThrowingPages<T: Codable & Sendable>: SyncSequence {
    public typealias Element = PageStruct<T>
    
    private let fetch: () throws -> PageStruct<T>
    public init(fetch: @escaping () throws -> PageStruct<T>) {
        self.fetch = fetch
    }
    /// Make an iterator that replays `fetch` on each `next()`.
    public func makeIterator() -> Iterator {
        Iterator(fetch: fetch)
    }
    /// Requests the following pages lazily, one per `next()` call.
    public struct Iterator: SyncIteratorProtocol {
        private let fetch: () throws -> PageStruct<T>
        private var hasMore = true
        
        init(fetch: @escaping () throws -> PageStruct<T>) {
            self.fetch = fetch
        }
        public mutating func next() throws -> PageStruct<T>? {
            guard hasMore else { return nil }
            let page = try fetch()
            hasMore = page.has_more ?? false
            guard !page.data.isEmpty else { return nil }
            return page
        }
    }
}
