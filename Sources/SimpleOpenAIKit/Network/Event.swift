//
//  Event.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/20/26.
//

import Foundation

public struct Event: Sendable {
    public var id: String?
    public var event: String?
    public var data: String?
    public var retry: Int?
}
