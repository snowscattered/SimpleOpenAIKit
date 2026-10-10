//
//  MessageContentBlockSource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/7/26.
//
import Foundation
import SimpleCodableMacro

@CodableByConstant
@nonexhaustive
public enum MessageContentBlockSourceContents {
    case text(MessageTextBlock)
    case image(MessageImageBlock)
}

@SingleOrArray
public enum MessageContentBlockSourceContent {
    case string(String)
    case array([MessageContentBlockSourceContents])
}

@BaseModelNoWithExtra
@PublicInit
public struct MessageContentBlockSource {
    public static let type: String = "content"
    public var content: MessageContentBlockSourceContent
}
