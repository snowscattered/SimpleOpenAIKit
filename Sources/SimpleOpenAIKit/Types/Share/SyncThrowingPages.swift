//
//  SyncThrowingPages.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/17/26.
//

import Foundation
import SimpleCodableMacro

/// Blocking page iterator: calls `fetch` again for every element until a page reports `has_more` false
/// or arrives empty.
@BaseModelWithExtra
@PublicInit
public struct SyncThrowingPages<Parameter: Sendable, Result: BaseModel>: SyncSequence, Hashable {
    // MARK: Hashable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.data == rhs.data && lhs.has_more == rhs.has_more && lhs.extra == rhs.extra
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(data)
        hasher.combine(has_more)
        hasher.combine(extra)
    }
    // MARK: Codable
    public let data: [Result]
    public let has_more: Bool?
    public let next_page: [String]?  // Anthropic only
    public init(data: [Result], has_more: Bool?, next_page: [String]?) {
        self.data = data
        self.has_more = has_more
        self.next_page = next_page
    }
    enum CodingKeys: String, CodingKey, CaseIterable {
        case data
        case has_more
        case next_page
    }
    // MARK: Function
    public func has_next_page() -> Bool {
        return self.has_more ?? false
    }
    public func next_page_param() -> Parameter? {
        return self.next
    }
    public func get_next_page() throws -> Self? {
        guard has_next_page(), let next, let fetch else { return nil }
        return try .init(parameters: next, fetch: fetch)
    }
    // MARK: SyncSequence
    private var next: Parameter?
    private var fetch: (@Sendable (Parameter) throws -> (page: Self, next: Parameter))?
    init(
        parameters: Parameter,
        fetch: @escaping @Sendable (Parameter) throws -> (page: Self, next: Parameter)
    ) throws {
        let (page, next) = try fetch(parameters)
        self.data = page.data
        self.has_more = page.has_more
        self.next_page = page.next_page
        self.extra = page.extra

        self.next = next
        self.fetch = fetch
    }
    public func makeIterator() -> Iterator {
        Iterator(page: self)
    }
    public struct Iterator: SyncIteratorProtocol {
        private var remaining: ArraySlice<Result>
        private var page: SyncThrowingPages<Parameter, Result>
        init(page: SyncThrowingPages<Parameter, Result>) {
            self.page = page
            self.remaining = ArraySlice(page.data)
        }
        public mutating func next() throws -> Result? {
            while remaining.isEmpty {
                guard let next = try page.get_next_page() else { return nil }
                page = next
                remaining = ArraySlice(page.data)
            }
            return remaining.popFirst()
        }
    }
}
