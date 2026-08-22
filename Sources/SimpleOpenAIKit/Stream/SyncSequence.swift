//
//  SyncSequence.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/4/26.
//


import Foundation

// MARK: - SyncStream Protocal (like AsyncSequence)
/// A sequence that provides synchronous access to its elements.
public protocol SyncSequence<Element, Failure> {
    /// The type of iterator that produces elements of this sequence.
    associatedtype Iterator : SyncIteratorProtocol
    /// The type of element produced by this sequence.
    associatedtype Element where Self.Element == Self.Iterator.Element
    /// The type of errors produced when iteration over the sequence fails.
    associatedtype Failure = any Error where Self.Failure == Self.Iterator.Failure
    /// Creates the iterator that produces elements of this sequence.
    ///
    /// - Returns: An instance of the `Iterator` type used to produce
    /// elements of the sequence.
    func makeIterator() -> Self.Iterator
    
    /// Used for handling synchronous blocking
    func signal() -> Void
}
extension SyncSequence {
    public func signal() -> Void { }
}

/// A type that supplies the values of a sequence one at a time.
public protocol SyncIteratorProtocol<Element, Failure> {
    /// The type of element traversed by this iterator.
    associatedtype Element
    /// The type of failure produced by iteration.
    associatedtype Failure : Error = any Error
    /// Advances to the next element and returns it, or ends the
    /// sequence if there is no next element.
    ///
    /// - Returns: The next element, if it exists, or `nil` to signal the end of
    ///   the sequence.
    mutating func next() throws(Failure) -> Self.Element?
}
